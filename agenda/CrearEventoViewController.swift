//
//  CrearEventoViewController.swift
//  agenda
//
//  Created by Apps2M on 18/1/23.
//

import UIKit

class CrearEventoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var date: UIDatePicker!
    
    
    @IBOutlet weak var escribirTexto: UITextField!

    
    @IBAction func agregarEvento(_ sender: UIButton) {
        
        let morancho: String = escribirTexto.text!
        
        let tacos = Int(date.date.timeIntervalSince1970 * 1000)
        
        let parameters: [String: Any] = ["name": morancho, "date": tacos]

        guard let url = URL(string: "https://superapi.netlify.app/api/db/eventos") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        request.httpBody = httpBody

        let session = URLSession.shared
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
