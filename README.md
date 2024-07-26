# Todo Android Application
### This is a simple Todo application built with Flutter. It allows users to add, view, and manage their tasks efficiently. The application persists tasks using local storage.

## Features
- Add new tasks
- View all tasks
- Mark tasks as completed
- Persist tasks using local storage

// ## Screenshots


## Project Structure
### main.dart file
The main entry point of the application. It sets up the main widget and initializes the state.

### task.dart file
Defines the "Task" class which models a task with properties like "id", "title", and "completed". Includes methods to convert tasks to/from JSON.

### readandwrite.dart file
Handles reading and writing tasks to local storage. Uses the "path_provider" package to get the application's document directory and stores tasks in a JSON file.

## Usage
- To add a new task, click the add button and enter the task title.
- To mark a task as completed, tap on the task.
- All tasks are automatically saved and loaded on app restart.

## Dependencies
- [Flutter](https://flutter.dev/)
- path_provider

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/DeepShah1406/SCT_AD_2/blob/master/LICENSE) file for details.

## Contact
- E-Mail ID : [Deep Shah](shahdeep1406@gmail.com)
- GitHub : [Deep Shah](https://github.com/DeepShah1406)

## Acknowledgements
- Flutter framework for providing the necessary tools and libraries.
- The open-source community for their continuous support and contributions.
