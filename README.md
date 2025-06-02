# TODO List Application Flutter Course Assignment

Create a simple mobile app, which allows users to add, view, and delete tasks. The app should have the following features and elements:
    
**1. Homepage:**
- Shows a list with the added tasks.
- Has a button (for example FloatingActionButton) for adding a new task.
- Use ListView.builder to dynamically create the list of tasks.
- Every element of the list (ListTile) should have:
  - Task description
  - An icon, showing the status of the task (done or not done).
- By pressing an element of the list, the user needs to be able to edit the task and mark it as done or not done.

**2. Add/Edit Task Screen:**
- Has TextField for creating or editing the task description.
- Has a button to save the task.
- By adding a new task, the task is added to the list on the homepage.
- By editing a task, the task is updated in the list on the homepage.

## Technical requirements:

- **Use these widgets:**
  - Text
  - Image
  - Icon
  - TextField
  - ListView
  - Scaffold
  - AppBar
  - FloatingActionButton
  - ElevatedButton
- **Navigator:** Use Navigator to navigate between the homepage and the add/edit task screen.
- **State Management:**
  - Use StatefulWidget for the pages, which need to change their state.
  - Use setState to update the UI when the state changes.
- **Responsive Design:** 
  - Think about how the app will look on different screen sizes.
- **Data Management:**
  - For this task you can use a simple List in StatefulWidget to store the tasks.
- **Task Deletion:**
  - Implement a way to delete a task from the list.
- **Additional requirements (optional):**
  - Implement a way to mark tasks as done or not done.
  - Add TextField validation to ensure that the task description is not empty.
  - Task persistence between sessions.