// Require module:
var MY_SLACK_WEBHOOK_URL = 'yourapiurl';
var slack = require('slack-notify')(MY_SLACK_WEBHOOK_URL);


slack.alert({
  text: ':sparkles: New version alive',
  fields: {
    'Information': 'Data base updated',
    'link': 'www.sitename.flinked.fr'
  },
});