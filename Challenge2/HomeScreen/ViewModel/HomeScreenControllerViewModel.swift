//
//  HomeScreenControllerViewModel.swift
//  Challenge2
//
//  Created by Anwesh M on 08/02/22.
//

import Foundation
import UIKit
import CoreData

class HomeScreenControllerViewModel: NSObject{
    
    weak var delegate: DataFromAPI?
    
    func fetchDataFromServer(){
        
        var request = URLRequest(url: URL(string: "https://www.breakingbadapi.com/api/characters?limit=100")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
            
            guard error == nil else{
                print("API Error")
                return
            }
            
            do {
                let characters = try JSONDecoder().decode(CharactersModel.self, from: data!)
                print(characters)
                DispatchQueue.main.async {
                    self?.saveDataIntoCoreData(characters: characters)
                    self?.fetchCharactersData()
                    self?.delegate?.onDatafetched(characters: characters)
                }
                
            } catch {
                print("error \(String(describing: error))")
            }
        })
        
        task.resume()
    }
    
    
    func saveDataIntoCoreData(characters: CharactersModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        deleteAllDataInCoreData()
        for char in characters{
            //2
            let entity = NSEntityDescription.entity(forEntityName: "Characters", in : managedContext)!
            //3
            let character =  Characters(entity: entity, insertInto: managedContext)
            character.name = char.name
            character.charId = Int64(char.charID ?? 0)
            character.status = char.status?.rawValue
            character.occupation = char.occupation!.joined(separator: " ")
            character.imageURL = char.img
            
            do {
                try managedContext.save()
            } catch
                let error as NSError {
                print("Could not save. \(error),\(error.userInfo)")
            }
        }
    }
    
    func deleteAllDataInCoreData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Characters")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
    }
    
    
    
    func fetchCharactersData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Characters> = Characters.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        // Perform Fetch Request
        managedContext.perform { [weak self] in
            do {
                // Execute Fetch Request
                let characters = try fetchRequest.execute()
                var charactersData: [CharacterModel] = []

                for char in characters{
                    let character: CharacterModel = CharacterModel(charID: Int(char.charId), name: char.name, birthday: nil, occupation: char.occupation?.components(separatedBy: " "), img: char.imageURL, status: .init(rawValue: char.status!.description), nickname: nil, appearance: nil, portrayed: nil, category: nil, betterCallSaulAppearance: nil)
                    charactersData.append(character)
                }
                self?.delegate?.onDatafetched(characters: charactersData)
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }

    
}


protocol DataFromAPI: NSObject{
    func onDatafetched(characters: CharactersModel)
}
