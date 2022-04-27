# Employee Directory

## Build tools & versions used

- Xcode 13.3.1
- Swift 5
- UIKit
- Auto Layout

## Steps to run the app

1. Open the app. The user will be presented with the list of employees in order of which they are parsed
2. To sort by name, press the `Name` button on the left side of the navigation bar
3. To sort by team, press the `Team` button on the right side of the navigation bar
4. To sort by default order, or to refresh the list, pull down on the list until the loading spinner is full, and then release

## What areas of the app did you focus on?

### Overview

This application is structured with an MVVM archiecture. I chose this archiecture with the focus on modularity and longevity. In the event where I would continue to expand on the app which would require more dependent classes, MVVM facilitates easier organization and focuses on the independence of modules, only knowing what is necessary to know.

MVVM is also a great architecture for unit testing, keeping components modular to isolate them and making code coverage easier.

### Framework & Interface Builder Choice

One of the major design decisions for this app was framework choice. When I first began as an iOS engineer, I learned to structure views programmatically in Objective-C with UIKit. After learning about the capabilities of Storyboard and SwiftUI, it was tempting to move to those frameworks due to their convenience.

But Storyboard, especially in an industry setting, can be a huge pain and can hide a lot of technical detail when collaborating with other engineers.

I chose to use UIKit as I believe it is a great foundation for iOS engineers to understand the ebbs and flows of an iOS application. Solidifying my knowledge of UIKit and understanding iOS application architecture will help me create better quality products in the future, as SwiftUI continues to grow and become the norm.

### Hierarchy Breakdown

`DirectoryViewModel` contains all the business logic, specifically modifying the employees list and calling the JSON endpoint to receive the list of employees to display.

The app is based on two models, `Employees` and `Employee`. `Employees` only contains an array of `Employee`s, but I wanted to separate these with the intention of adding on to these models. We could potentially add more properties to each employee, or to the list of employee itself. Therefore, splitting them into two separate classes keeps the hierarchical structure more organized in the long run.

The Views are housed in the `ViewController` and the `EmployeeTableViewCell`. The `ViewController` sets up the navigation bar and the refresh control, as well as trigger the JSON data fetch in the view model. The view controller also conforms to `UITableViewDataSource` and `UITableViewDelegate`, setting up the table view. `EmployeeTableViewCell` contains the constraints necessary to format employee data, structured with Auto Layout. Tapping on the view cell will print the employee's name and team in the console, as a placeholder for future feature implementations.

This is a high-level UML diagram of the MVVM archiecture.

<img width="1000" alt="Screen Shot 2022-04-27 at 2 33 35 PM" src="https://user-images.githubusercontent.com/20309397/165634835-34be387c-f5c3-4ded-966d-71d05f2418af.png">

### Asynchronous Programming

One of my high-priority focuses was on asynchronously fetch data from the JSON endpoint and rendering it to the table view while making the user experience seamless and smooth. I was able to accomplish this by passing a completion block that updates and re-renders the tableview from the view controller to the fetching methods. Therefore, once data is returned, it will display to the user.

```
func fetchEmployeeData(urlString: String) {
        viewModel.fetchEmployeeData(url: urlString) { (newEmployeeList, error) in
            guard error == nil else {
                print(error ?? "[ViewController] Error fetching employee data")
                return
            }

            DispatchQueue.main.sync {
                self.replaceEmployeeListWithNewList(newEmployeeList: newEmployeeList!)
            }
        }
    }

func replaceEmployeeListWithNewList(newEmployeeList: [Employee]) {
        viewModel.clearEmployeeList()

        for employee in newEmployeeList {
            self.viewModel.addEmployee(newEmployee: employee)
        }

        self.tableView.reloadData()
    }
```

Because data can be fetched before loading any views, there was no need for any reactive frameworks like Combine.

### Caching

For caching employee images, I utilized a standard NSCache in a `UIImageView` extension, that runs checks while loading images into the table view. I only used the small images, which made fetching and caching a lot quicker.

## What was the reason for your focus? What problems were you trying to solve?

As mentioned above, my goal with building this app was with the intention of developing it further. Therefore, I focused primarily on modularity and scalability of the app. App architecture can get tangled very easily, especially with industry-level monolithic code bases. I believe it's important to start off with a firm foundation with a future focus in mind.

Secondly, as mentioned above I wanted to provide the user with a smooth experience with the app, which can be an issue when dealing with asynchronous data handling. The combination of fetching and populating data before rendering and caching large files contributes to efficiency.

## How long did you spend on this project?

I spent around 7-8 hours total on this project throughout the week.

## Did you make any trade-offs for this project? What would you have done differently with more time?

Most importantly, I would go further with organization by conforming classes to protocols. If I were to add more similar components, protocols would come in handy for better reusability and class separation. To add on, I would also remove the table view and refresh components out of the view controller and initialize them in their own classes. I'm a firm believer in organization and scalability!

A feature add-on I would like to implement is to add a drop down in the navigation bar that provides the options to sort via name, team, email, etc. Having two sort buttons in the navigation bar is definitely not ideal.

Lastly, I would have liked to add dark mode support as well, for the extra brownie points.

## What do you think is the weakest part of your project?

I think the weakest part of my project is the separation of components. As mentioned above I definitely could organize component initialization and methods into their own defined classes. That way, classes like `ViewController` can be easier to read and contain less lines of code.

## Did you copy any code or dependencies? Please make sure to attribute them here!

I did not use any third-party code or dependencies when working on this project.

## Is there any other information you’d like us to know?

This is my first time writing an application in Swift! At Snap, I had been primarily working with Objective-C, though I have been learning Swift on the side to keep up with modern coding languages.

It was awesome to design my own MVVM application from scratch. Being able to fuse my experiences with MVVM and programmatically designing with UIKit into my own Swift application was a great learning experience for me.
