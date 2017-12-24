import TodoistAPI from 'todoist-js';

const todoist = new TodoistAPI('663c247fdad54d4ea4ddd4c290ef3607');

todoist.completed.get_stats().then(stats => {
  console.log(stats.karma_trend);
});