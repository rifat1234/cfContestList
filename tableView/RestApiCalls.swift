//
//  RestApiCalls.swift
//  someProject
//
//  Created by Rifat Monzur on 24/10/17.
//  Copyright © 2017 Rifat Monzur. All rights reserved.
//

import UIKit

class RestApiCalls: NSObject {
    static func deleteData(url:String) -> Void {
        let firstTodoEndpoint: String = url
        var firstTodoUrlRequest = URLRequest(url: URL(string: firstTodoEndpoint)!)
        firstTodoUrlRequest.httpMethod = "DELETE"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: firstTodoUrlRequest) {
            (data, response, error) in
            guard let _ = data else {
                print("error calling DELETE on /todos/1")
                return
            }
            print("DELETE ok")
        }
        task.resume()
    }
    
    class func getDataFromURL(url:String) -> Void {
        if(!self.isURL(url: url)){
            return
        }
        let urlRequest = URLRequest(url: URL(string: url)!  )
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                //print("The todo is: " + todo.description)
                
                guard let todoArray = todo["result"] as? [Any] else{
                    print("Not an array ");
                    return;
                }
                
                print("Size of array: \(todoArray.count)");
                
                var index:Int = 0;
                for contest in todoArray{
                    
                    if let dict = contest as? Dictionary<String, Any> {
                        guard let nameOfContest:String = dict["name"] as? String else{
                            print("Could not get the contest name")
                            return
                        }
                        print("Name of contest \(index): \(nameOfContest)")
                        index += 1;
                    }
                    
                }
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
        
    }
    static func postData(url:String,newTodo:[String:Any]) -> Void {
        let todosEndpoint: String = url
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedTodo.description)
                
                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
    private static func isURL(url:String) -> Bool {
        guard  (URL(string: url) != nil)  else {
            print("Error: cannot create URL")
            return false;
        }
        return true;
    }

}
