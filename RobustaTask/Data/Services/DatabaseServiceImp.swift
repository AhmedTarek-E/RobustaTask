//
//  DatabaseServiceImp.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 25/05/2022.
//

import UIKit
import CoreData

class DatabaseServiceImp: DatabaseService {
    init(managedContext: NSManagedObjectContext) {
        let privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMoc.parent = managedContext
        self.managedContext = privateMoc
        self.mainContext = managedContext
    }
    
    let managedContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    func insert(repos: [MiniRepo]) -> Observable<Void> {
        let observableController = ObservableController<Void>()
      
        DispatchQueue.global().async {
            repos.forEach { [weak self] repo in
                guard let self = self else { return }
                self.save(managedContext: self.managedContext, repo: repo)
            }
            observableController.push(value: ())
        }
        
        return observableController
    }
    
    private func save(managedContext: NSManagedObjectContext, repo: MiniRepo) {
        let entity =
            NSEntityDescription.entity(forEntityName: "Repository",
                                       in: managedContext)!
        let repoEntity = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        repoEntity.setValue(repo.basicInfo.id, forKey: "id")
        repoEntity.setValue(repo.basicInfo.name, forKey: "name")
        repoEntity.setValue(repo.basicInfo.name.lowercased(), forKey: "searchableName")
        repoEntity.setValue(repo.basicInfo.description, forKey: "repoDescription")
        repoEntity.setValue(repo.owner.id, forKey: "ownerId")
        repoEntity.setValue(repo.owner.name, forKey: "ownerName")
        repoEntity.setValue(repo.owner.avatar, forKey: "ownerAvatar")
        
        do {
            try managedContext.save()
            mainContext.performAndWait {
                do {
                    try mainContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchRepos(searchKey: String, page: Int) -> Observable<[MiniRepo]> {
        let controller = ObservableController<[MiniRepo]>()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Repository")
        
        if searchKey.count >= 2 {
            if page > 1 {
                controller.push(value: [])
                return controller
            } else {
                fetchRequest.predicate = NSPredicate(format: "searchableName CONTAINS[cd] %@", searchKey.lowercased())
            }
            
        } else {
            fetchRequest.fetchLimit = 10
            fetchRequest.fetchOffset = 10 * page-1
        }
        
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            do {
                let reposObjects = try self.managedContext.fetch(fetchRequest)
                
                let repos = reposObjects.map { object in
                    return self.mapToMiniRepo(object: object)
                }
                controller.push(value: repos)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                controller.push(value: [])
            }
        }
        
        return controller
    }
    
    private func mapToMiniRepo(object: NSManagedObject) -> MiniRepo {
        return MiniRepo(
            basicInfo: RepoBasicInfo(
                id: object.value(forKey: "id") as! Int,
                name: object.value(forKey: "name") as! String,
                description: object.value(forKey: "repoDescription") as! String
            ),
            owner: RepoOwner(
                id: object.value(forKey: "ownerId") as! Int,
                name: object.value(forKey: "ownerName") as! String,
                avatar: object.value(forKey: "ownerAvatar") as! String
            )
        )
    }
    
}
