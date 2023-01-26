//
//  LogInViewController.swift
//  agenda
//
//  Created by Apps2M on 18/1/23.
//

import UIKit

class LogInViewController: UIViewController {
    
 
    @IBOutlet var inputNombre: UITextField!
    
    @IBOutlet var inputContraseña: UITextField!
    var usuarios: [Usuario] = []
    
    @IBAction func pantallaListaEventos(_ sender: Any) {
        let url = URL(string: "https://superapi.netlify.app/api/login")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "user": inputNombre.text!,
            "pass": inputContraseña.text!
        ]
        
        struct ResponseObject<T: Decodable>: Decodable {
            let form: T
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error{
            print(error.localizedDescription)
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Usuario>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "pantallaListaEventos", sender: sender)
                    }
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        task.resume()
    }
    
    
    @IBAction func pantallaCrearUsuario(_ sender: UIButton) {
        performSegue(withIdentifier: "pantallaCrearUsuario", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pantallaListaEventos" {
            let svc = segue.destination as? ListaEventosViewController
        }
        if segue.identifier == "pantallaCrearUsuario" {
            let svc = segue.destination as? CrearUsuarioViewController
        }
    }
}
