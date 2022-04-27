//
//  ViewController.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/21/22.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var viewModel: DirectoryViewModel!
    
    var tableView: UITableView!
    var tableRefresh: UIRefreshControl!
    var navBar: UINavigationBar!
    
    let employeeListUrl = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModel()
        setupNavigationBar()
        setupTableView()
        setupRefreshControl()
        fetchEmployeeData(urlString: employeeListUrl)
    }
    
    // MARK: Setup Views
    
    func setupNavigationBar() {
        navBar = UINavigationBar()
        view.addSubview(navBar)

        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true

        let navItem = UINavigationItem(title: "Employee Directory")
        let sortByNameItem = UIBarButtonItem(title: "Name", style: .done, target: nil, action: #selector(handleSortByName))
        let sortByTeamItem = UIBarButtonItem(title: "Team", style: .done, target: nil, action: #selector(handleSortByTeam))

        navItem.leftBarButtonItem = sortByNameItem
        navItem.rightBarButtonItem = sortByTeamItem

        navBar.setItems([navItem], animated: false)
        
        navigationItem.title = "Employee List"
    }

    func setupRefreshControl() {
        tableRefresh = UIRefreshControl()
        tableRefresh.tintColor = .gray
        tableRefresh.addTarget(self, action: #selector(handleRefreshList(_:)), for: .valueChanged)
        
        self.tableView.refreshControl = tableRefresh
    }
    
    func setupTableView() {
        tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        tableView.register(EmployeeTableViewCell.self,
                           forCellReuseIdentifier: "EmployeeTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        let employeeData = viewModel.employees[indexPath.row]
        cell.nameLabel.text = employeeData.fullName
        cell.teamLabel.text = employeeData.teamName
        cell.emailLabel.text = employeeData.emailAddress
        cell.profileImageView.loadImage(urlString: employeeData.smallPhotoUrl)
        
        return cell
    }
    
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(viewModel.employees[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    // MARK: Helper Methods
    
    func setViewModel() {
        viewModel = DirectoryViewModel.init()
    }
    
    func replaceEmployeeListWithNewList(newEmployeeList: [Employee]) {
        viewModel.clearEmployeeList()

        for employee in newEmployeeList {
            self.viewModel.addEmployee(newEmployee: employee)
        }
        
        self.tableView.reloadData()
    }
    
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
    
    @objc func handleRefreshList(_ tableRefresh: UIRefreshControl) {
        viewModel.clearEmployeeList()
        fetchEmployeeData(urlString: employeeListUrl)
        tableRefresh.endRefreshing()
    }
    
    @objc func handleSortByName() {
        let newSortedEmployeeList: [Employee] = self.viewModel.employees.sorted() { $0.fullName < $1.fullName }
        replaceEmployeeListWithNewList(newEmployeeList: newSortedEmployeeList)

    }
    
    @objc func handleSortByTeam() {
        let newSortedEmployeeList: [Employee] = self.viewModel.employees.sorted() { $0.teamName < $1.teamName }
        replaceEmployeeListWithNewList(newEmployeeList: newSortedEmployeeList)
    }
}

