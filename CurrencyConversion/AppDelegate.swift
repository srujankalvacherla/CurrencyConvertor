//
//  AppDelegate.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CurrencyConversion")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
/*


Here’s a professional resume tailored to the job description and your experience at Verizon:

⸻

[Your Name]

[Your Email] | [Your Phone Number] | [Your LinkedIn Profile] | [Your Location]

Professional Summary

Results-driven Senior Mobile Application Developer with extensive experience in designing, developing, and implementing innovative mobile solutions. Proven expertise in iOS and cross-platform development, backend architecture, and integrating high-availability applications. Adept at leading teams, collaborating with cross-functional stakeholders, and delivering customer-centric products. Passionate about emerging technologies and driving innovation in mobile applications.

Technical Skills
	•	Programming Languages & Frameworks: Swift, SwiftUI, Objective-C, Kotlin, KMM, JavaScript, ReactJS, CSS, HTML
	•	Mobile Development: iOS (Xcode, UIKit, CoreData), Android (Kotlin, XML)
	•	Backend & Networking: WebRTC, WebSockets, gRPC, SSE, UDP, HTTP, TCP/IP, IPSEC
	•	Tools & Platforms: Postman, Firebase, AWS Cloud, CI/CD Pipelines
	•	Project Management: Agile methodology, Stakeholder management, Risk mitigation

Professional Experience

Senior Engineer – Cstl-App Dev

Verizon | [Start Date] – Present
	•	Led a team of 7 engineers to drive business and innovation through mobile applications.
	•	Developed and enhanced multiple applications for Verizon Stores, including:
	•	mPOS (Mobile Point-of-Sale) – Enhanced digital transactions for retail operations.
	•	Vending Machine App & Payment Terminal App – Streamlined digital payments.
	•	Video Assist – Implemented video calling feature connecting customers to store agents.
	•	CMSI & Mitek for Digital Driver’s License – Integrated advanced security and authentication solutions.
	•	Owned end-to-end development, from designing and debugging to deployment and maintenance.
	•	Worked closely with offshore and onshore teams to align technical solutions with business needs.
	•	Collaborated with cross-functional teams to define project scope, release plans, and feature roadmaps.
	•	Championed innovation by introducing new technologies and presenting them in multiple forums.

Engineer III – Cstl-App Dev

Verizon | [Start Date] – [End Date]
	•	Developed key features in Verizon mPOS, enabling seamless digital transactions at retail stores.
	•	Built an Android version of mPOS from scratch using Kotlin Multiplatform Mobile (KMM).
	•	Led the development of the D2D (Door-to-Door) Project, Pick & Pack Program, and Plan Builder.
	•	Focused on performance optimization, security enhancements, and scalability of mobile solutions.
	•	Acted as a key stakeholder in feature development, ensuring seamless customer experiences.

Key Achievements
	•	Recognized as L2 Achiever in Innovation Platform SIP for outstanding contributions.
	•	Presented Innovation Idea Demos to the CEO and leadership team.
	•	Received multiple Spotlight Awards for innovation and accountability.

Education

[Your Degree], [Your University] | [Year of Graduation]

Certifications (If Any)
	•	[Relevant Certification 1]
	•	[Relevant Certification 2]

Additional Skills
	•	Strong leadership and mentorship experience guiding ACT teams.
	•	Expertise in high-availability mobile architectures and security best practices.
	•	Passion for researching and prototyping new technologies for innovation.






*/
