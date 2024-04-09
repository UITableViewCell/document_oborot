//
//  FirebaseManager.swift
//  document_oborot
//
//  Created by 123 on 07.04.2024.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager{
    static var shared = FirebaseManager()
    
    
    func registerNewUser(user: UserData) {
        Auth.auth().createUser(withEmail: user.login, password: user.password) { result, err in
            guard err == nil else {
                print(err?.localizedDescription ?? "none error")
                return
            }
            
            guard let uid = result?.user.uid else {return}
            Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData([
                    "login": user.login,
                    "pass": user.password
                ], merge: true) { err in
                    guard err == nil else {
                        print(err?.localizedDescription ?? "none error")
                        return
                    }
                    print("saved")
                }
            
        }
    }
    
    func loginUser(user: UserData, completion: @escaping (String) -> Void) {
        
        Auth.auth().signIn(withEmail: user.login, password: user.password) {result, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "none error")
                return
            }
            print(result?.user.uid as Any)
            guard let uid = result?.user.uid else {return}
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            docRef.getDocument { document, error in
                guard let data = document?.data() else {return}
                guard let role = data["role"] as? String else {return}
                completion(role)
            }
            
            
            
            
        }
    }
    
    func newTask(task: Order, completion: @escaping () -> Void) {
        
        guard let taskID = task.taskID else {
            Firestore.firestore()
                .collection("tasks")
                .document()
                .setData([
                    "name": task.name,
                    "text": task.text,
                    "implementer": task.implementer,
                    "status": task.status,
                    "docId": task.docId,
                    "creator": task.creator
                ], merge: true) { error in
                    guard error == nil else {
                        print(error?.localizedDescription ?? "none error")
                        return
                    }
                    completion()
                }
            return
            
        }
        
        Firestore.firestore()
            .collection("tasks")
            .document(taskID)
            .setData([
                "name": task.name,
                "text": task.text,
                "implementer": task.implementer,
                "status": task.status,
                "docId": task.docId,
                "creator": task.creator
            ], merge: true) { error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "none error")
                    return
                }
                completion()
            }
        
      
        
    }
    
    
    func getAllTasks(role: Int, completion: @escaping ([Order]) -> Void) {
        Firestore.firestore()
            .collection("tasks")
            .getDocuments(completion: { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Ошибка при получении данных из Firestore: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var data: [Order] = []
                for document in snapshot.documents {
                    let rowData = document.data()
                    let taskId = document.documentID
                    data.append(Order(name: rowData["name"]! as! String,
                                      text: rowData["text"]! as! String,
                                      implementer: rowData["implementer"]! as! Int,
                                      creator: rowData["creator"]! as! Int,
                                      status: rowData["status"]! as! String,
                                      docId: rowData["docId"]! as! String,
                                      taskID: taskId
                                     )
                                )
                }
                
                completion(data)
            })

    }
    
    
    
    // MARK: - Files
    
    func loadFile(fileURL: URL, completion: @escaping (String) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("files")
        let fileRef = storageRef.child(fileURL.lastPathComponent)
        let fileName = fileURL.lastPathComponent
        print(fileName)
        let uploadTask = fileRef.putFile(from: fileURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Ошибка при загрузке файла: \(error.localizedDescription)")
                return
            }

            print("Файл успешно загружен.")
            completion(fileName)
            
            
        }
        
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Процент загрузки: \(percentComplete)%")
        }
        
        
        uploadTask.observe(.success) { snapshot in
            print("Загрузка завершена.")
        }
        
        
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                if let errorCode = StorageErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .objectNotFound:
                        print("Файл не найден.")
                    case .unauthorized:
                        print("У вас нет разрешения для доступа к этому файлу.")
                    case .cancelled:
                        print("Загрузка была отменена.")
                    case .unknown:
                        print("Произошла неизвестная ошибка.")
                    default:
                        print("Произошла ошибка: \(error.localizedDescription)")
                    }
                }
            }
        }
          
        
    }
    
    func downloadFile(fileName: String , completion: @escaping (URL) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("files/" + fileName)
        
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                   print("Не удалось получить путь к директории Documents.")
                   return
               }
        let fileURL = documentsURL.appendingPathComponent("downloadedFile.pdf")
        
        
        storageRef.write(toFile: fileURL) { url, error in
            if let error = error {
                print("Ошибка при загрузке файла: \(error.localizedDescription)")
                return
            }
            
            print("Файл успешно скачан и сохранен по адресу: \(fileURL)")
            
            completion(fileURL)
            
        }
        
        
        
        
    }
    
    


    
}

struct UserData{
    var login: String
    var password: String
}

struct Order {
    var name: String
    var text: String
    var implementer: Int
    var creator: Int
    var status = "new"
    var docId = ""
    var taskID: String?
    

}
