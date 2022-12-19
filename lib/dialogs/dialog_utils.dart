enum DialogSource { homeView, templateView, historyView, template }

enum SnackBarType { info, error }

class DialogUtils {
  static String getHelpTextBySource(DialogSource source) {
    switch (source) {
      case DialogSource.template:
        return "Templates are used to create recurring tasks more quickly. Use them for actions that take place daily or several times a month.\r\n\r\nWith this checkbox you can opt-in to create a task and a template. Then you can create follow-up tasks from the template view whenever you need them!";
      case DialogSource.historyView:
        return "This is the history view. You can find all your completed tasks here. The tasks are ordered by the date they were finished. Recently finished tasks appear at the top.\r\n\r\n"
            "The button bar provides options to go back to the start page, to open this help dialog, and to clear your task history.\r\n\r\n"
            "To see all available options, long-press a task and use the popup menu.";
      case DialogSource.homeView:
        return "This is the start page of your application. All your open tasks are listed here and grouped by category.\r\n\r\n"
            "The button bar provides options to create a new task or template, open this help dialog, navigate to your list of completed tasks, and navigate to your templates.\r\n\r\n"
            "The task list allows to collapse/show category groups by tapping the arrows icon on the right. To edit task details, tap on the desired task. You will be redirected to the edit view. To mark a task as completed, swipe from left to right. After completion, the task will appear in your history view.\r\n\r\n"
            "To see all available options, long-press a task and use the popup menu.";
      case DialogSource.templateView:
        return "This is the template view. You can find all your created templates here.\r\n\r\n"
            "The button bar provides options to go back to the start page and to open this help dialog.\r\n\r\n"
            "To create a task from a template, just click on the icon button on the right of the desired template.\r\n\r\n"
            "To create a template, go back to the start screen, click on the \"+\" icon to create a new task, and activate the checkbox \"Set as template\" during the process.\r\n\r\n"
            "To see all available options, long-press a template and use the popup menu.";
      default:
        return "";
    }
  }

  static String getHelpTitleBySource(DialogSource source) {
    switch (source) {
      case DialogSource.template:
        return "What is a template?";
      case DialogSource.historyView:
        return "What can I do here?";
      case DialogSource.homeView:
        return "What can I do here?";
      case DialogSource.templateView:
        return "What can I do here?";
      default:
        return "";
    }
  }
}
