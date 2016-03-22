require('dotenv').config();
var knex = require('./app/shared/knex');
var Promise = require('bluebird');

// var users = [
//   10, 20, 30, 40
// ];
//
// knex.transaction(function(trx) {
//     return trx('poll')
//       .insert({
//         creator_id: 10,
//         name: 'Davidtestpoll3',
//         group_id: 14,
//         expires: '2016-03-06T06:36:09Z',
//         allow_new_restaurants: true,
//         created: '2016-03-06T06:36:09Z',
//       })
//       .returning('id')
//       .then(function(pollid) {
//         console.log('IIIIID: ' + pollid);
//         return Promise.map(users, function(userid) {
//           console.log('kommer till Promise.map');
//           return trx.insert({
//             user_id: userid,
//             poll_id: pollid[0],
//             joined: '2016-03-06T06:36:09Z'
//           }).into('poll_users');
//         });
//       });
//   })
//   .then(function(result) {
//     console.log(result);
//   })
//   .catch(function(error) {
//     console.log(error);
//   });
//

knex.pluck('id')
  .from('user')
  .where('id', '')
  .then(function(res) {
    console.log('SUCCESS');
    console.log(res);
  }).catch(function(err) {
    console.log('FAIL');
    console.log(err);
  });

console.log('yay');
