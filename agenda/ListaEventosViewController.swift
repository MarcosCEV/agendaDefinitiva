//
//  ListaEventosViewController.swift
//  agenda
//
//  Created by Apps2M on 18/1/23.
//

import Foundation
import UIKit


struct Pruebas: Codable {
    var results: [Prueba]
}

struct Prueba: Codable {
    var date: Double
    var name: String
    init(json: [String: Any])  {
        date = json["date"] as? Double ?? 0
        name = json["name"] as? String ?? ""
    }
}


class ListaEventosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    
    var eventos: [Evento] = []
    
    
    var pruebas = [Prueba]()
    
    
    func cargarEventos() {
        
        let url = URL(string: "https://superapi.netlify.app/api/db/eventos")
        
        URLSession.shared.dataTask(with: url!) {data, response, error in
            print("Data \(String(describing: data))")
            //print("Response \(String(describing: response))")
            if let _ = error {
                print("Error")
            }
            do {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data)
                    //print(String(describing: json))
                    self.eventos.removeAll()
                    for a in json as! [[String : Any]] {
                        self.eventos.append(Evento(json: a))
                    }
                }
                DispatchQueue.main.async {
                    self.tablaEventos.reloadData()
                }
                print( String(data: data!, encoding: .utf8))
            } catch let error{
                print(error)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaEventos.dataSource = self
        tablaEventos.delegate = self
        cargarEventos()
    }
    
    
    @IBOutlet weak var tablaEventos: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventoRow: EventoRow = tableView.dequeueReusableCell(withIdentifier: "eventoRowID", for: indexPath) as! EventoRow
        let evento = eventos[indexPath.row]
        let nuevaFecha = TimeInterval(eventos[indexPath.row].date / 1000)
        let nuevaDate = Date(timeIntervalSince1970: nuevaFecha)
        
        eventoRow.name.text = evento.name
        eventoRow.date.text = nuevaDate.formatted().description
        
        return eventoRow
    }

    @IBAction func añadirEvento(_ sender: Any) {
        performSegue(withIdentifier: "pantallaNuevoEvento", sender: sender)
    }
    
    @IBAction func recargarPantalla(_ sender: UIButton) {
        cargarEventos()
    }
    


}
