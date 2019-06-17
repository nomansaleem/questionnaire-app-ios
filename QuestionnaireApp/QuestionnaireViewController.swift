//
//  QuestionnaireViewController.swift
//  QuestionnaireApp
//
//  Created by Noman Saleem on 07/02/2019.
//  Copyright © 2019 Noman Saleem. All rights reserved.
//

import UIKit
import CoreData

class QuestionnaireViewController: UIViewController {

    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var q1Text: UITextField!
    @IBOutlet weak var q2Text: UITextField!
    @IBOutlet weak var q3Text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveData(_ sender: Any) {
        savingData()
    }
    
    @IBAction func searchData(_ sender: Any) {
        retrieveData()
    }
    
    @IBAction func deleteData(_ sender: Any) {
        deleteData()
    }
    
    func savingData(){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Data", in: managedContext)!
        
        
        //here adding 5 data with loop - replace this with your textfields
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(idText.text, forKeyPath: "id")
        user.setValue(q1Text.text, forKey: "q1")
        user.setValue(q2Text.text, forKey: "q2")
        user.setValue(q3Text.text, forKey: "q3")
        
        
        //The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    func retrieveData(){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", idText.text!)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: false)]
        //
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                // print(data.value(forKey: "id") as! String)
                idText.text = data.value(forKey:"id") as? String
                q1Text.text = data.value(forKey:"q1") as? String
                q2Text.text = data.value(forKey:"q2") as? String
                q3Text.text = data.value(forKey:"q3") as? String
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func deleteData(){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "Test3")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
