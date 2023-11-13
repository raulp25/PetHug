# Pethug App IOS - Clean architecture
This is a pet adoption app for iOS, launched for the Mexican market to help animals that need a home.
# About the project
### Features
- MVVM
- Coordinators
- Combine
- Modern Swift concurrency
- Programmatic UIKit 100%
- UICollectionViewCompositionalLayout
  - Lists created with list configuration instead of UITableViews
  - Cells with custom UIContentConfiguration
  - Diffable data source instead of UICollectionViewDataSource
- Firebase
  - Auth for authentication
  - Firestore as db
  - Firestorage as media storage

### Project Structure
```
app
├── pethug
│   ├── Core
│       ├── Extensions
│       ├── Utilities
│   ├── Data
│       ├── Services
│       ├── Managers
│       ├── Model
│       ├── Mappers
│       ├── Repository
│       ├── DataSource
│   ├── Domain
│       ├── Entity
│       ├── UseCase
│       ├── Repository
│   ├── Presentation
│       ├── Cells
│       ├── ChildView
│       ├── BaseComponents
│       ├── Containers
│       ├── Components
│       ├── Coordinators
│       ├── Screens
├── pethug Tests
|    ├──  Mocks
|    ├──  UnitTests
|    ├──  IntegrationTests
```
### Installation
1. Clone the repo
2. Create a new project in your Firebase console by clicking "Add project"
3. Create a Cloud Firestore database and Firestorage instance
4. Enable sign-in with email and password in Firebase Auth
5. Add the GoogleService-Info.plist to the project
6. Run the app

### Screenshots
[![f43b9e183628629-6544229a24560-1.png](https://i.postimg.cc/76GZJ1yk/f43b9e183628629-6544229a24560-1.png)](https://postimg.cc/34hTPvRS) 
[![2ed0ec183628629-65432b391efa5.png](https://i.postimg.cc/L5F2qrTt/2ed0ec183628629-65432b391efa5.png)](https://postimg.cc/ZBH12sXn)
[![93f750183628629-65432b391a2da.png](https://i.postimg.cc/6qhJ8TTK/93f750183628629-65432b391a2da.png)](https://postimg.cc/0KrH3kpX)
[![cd5dab183628629-65432b391e1eb.png](https://i.postimg.cc/B6cwgk3c/cd5dab183628629-65432b391e1eb.png)](https://postimg.cc/DJ0gfC88)
[![954c8a183628629-65432b392031e.png](https://i.postimg.cc/XYPMGRNr/954c8a183628629-65432b392031e.png)](https://postimg.cc/LJjQG01S)
[![912bd7183628629-65442527674d1.png](https://i.postimg.cc/fL465Y9Z/912bd7183628629-65442527674d1.png)](https://postimg.cc/cKm9Lgh5)
[![5672ba183628629-65432b39194ba.png](https://i.postimg.cc/hP4NCDfJ/5672ba183628629-65432b39194ba.png)](https://postimg.cc/4nM8yTvZ)
[![c46b2e183628629-65432b391b07f.png](https://i.postimg.cc/mZj51v8T/c46b2e183628629-65432b391b07f.png)](https://postimg.cc/SjXrwtBP)
[![f46a17183628629-65432b391c110.png](https://i.postimg.cc/W409NCdL/f46a17183628629-65432b391c110.png)](https://postimg.cc/zLXwpdw0)
[![db9499183628629-6544229a25236.png](https://i.postimg.cc/QxV09HFq/db9499183628629-6544229a25236.png)](https://postimg.cc/N5q1ZG7y)
