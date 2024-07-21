import UIKit
import CoreData

class CoreDataManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveOrUpdateUserProfile(id: UUID? = nil, fullName: String, gender: String, birthday: String, phoneNumber: String, email: String, userName: String, profileName: String, profileNickname: String, profileImage: UIImage?) {
        let context = self.context
        
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            let userProfile: UserProfile
            
            if let existingProfile = results.first {
                userProfile = existingProfile
            } else {
                userProfile = UserProfile(context: context)
                userProfile.id = UUID()
            }
            
            userProfile.fullName = fullName
            userProfile.gender = gender
            userProfile.birthday = birthday
            userProfile.phoneNumber = phoneNumber
            userProfile.email = email
            userProfile.userName = userName
            userProfile.profileName = profileName
            userProfile.profileNickname = profileNickname
            
            if let image = profileImage {
                userProfile.profileImage = image.jpegData(compressionQuality: 1.0)
            }
            
            try context.save()
        } catch {
            print("Failed to save or update user profile: \(error)")
        }
    }
    
    func fetchUserProfiles() -> [UserProfile]? {
        let context = self.context
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        
        do {
            let userProfiles = try context.fetch(fetchRequest)
            return userProfiles
        } catch {
            print("Failed to fetch user profiles: \(error)")
            return nil
        }
    }
}
