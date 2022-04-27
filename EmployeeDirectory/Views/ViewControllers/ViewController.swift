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
    
    let employeeListUrl = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModel()
        setupTableView()
        setupRefreshControl()
        fetchEmployeeData(urlString: employeeListUrl)
    }
    
    // MARK: Setup Views

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
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
    
    func fetchEmployeeData(urlString: String) {
        viewModel.fetchEmployeeData(url: urlString) { (newEmployeeList, error) in
            guard error == nil else {
                print(error ?? "[ViewController] Error fetching employee data")
                return
            }
            
            DispatchQueue.main.sync {
                for employee in newEmployeeList! {
                    self.viewModel.addEmployee(newEmployee: employee)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handleRefreshList(_ tableRefresh: UIRefreshControl) {
        viewModel.clearEmployeeList()
        fetchEmployeeData(urlString: employeeListUrl)
        tableRefresh.endRefreshing()
    }
}

