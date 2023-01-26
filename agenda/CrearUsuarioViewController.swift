//
//  CrearUsuarioViewController.swift
//  agenda
//
//  Created by Apps2M on 17/1/23.
//

import UIKit

class CrearUsuarioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var inputNombre: UITextField!
    
    @IBOutlet weak var inputContraseña: UITextField!
    
    
    @IBAction func aceptarUsuario(_ sender: UIButton) {
        let nuevoNombre: String = inputNombre.text!
        let nuevaContraseña: String = inputContraseña.text!
        
        if nuevoNombre.isEmpty || nuevaContraseña.isEmpty {
            print("Rellena todos los campos")
        }
        else {
            let parameters: [String: Any] = ["user": nuevoNombre, "pass": nuevaContraseña]

            guard let url = URL(string: "https://superapi.netlify.app/api/register") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            print(session)
            //usar Data URLRequest
            session.dataTask(with: request ) { (data, response, error) in

                if let response = response {
                    print(response)
                }
                if let data = data,
                let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    do {
                        //Elegimos jsonObject InputStream
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
