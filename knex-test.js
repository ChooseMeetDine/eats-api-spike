require('dotenv').config();
var knex = require('./app/shared/knex');
var Promise = require('bluebird');


// return knex.transaction(function(trx) {
//   trx('polls')
//     .insert({
//       creator: req.validUser,
//       name: req.validBody.name,
//       group: body.group,
//       expires: body.expires,
//       allow_new_restaurants: body.allowNewRestaurants,
//     })
//     .then(function(id) {
//       return trx('poll_users')
//         .insert({
//           poll: id,
//           user: body.users[0]
//         });
//     });
// });

// knex.select('name').from('user').then(function(result) {
//     console.log(result);
//   })
//   .catch(function(error) {
//     console.log('ERRRORRRRORORORORO: ' + error);
//   });


// knex.insert({
//     creator: 10,
//     name: 'Davidtestpoll',
//     group: 14,
//     expires: '2016-03-06T06:36:09Z',
//     fixed_vote: true,
//     created: '2016-03-06T06:36:09Z',
//   }).into('poll')
//   .then(function(result) {
//     console.log(result);
//   })
//   .catch(function(error) {
//     console.log(error);
//   });


var users = [
  10, 20, 30, 40
];

// var insertPollUser = function(userID, pollID) {
//   return knex.insert({
//     user: userID,
//     poll: pollID,
//     joined: '2016-03-06T06:36:09Z'
//   }).into('poll_users');
// };


knex.transaction(function(trx) {
    return trx('poll')
      .insert({
        creator_id: 10,
        name: 'Davidtestpoll3',
        group_id: 14,
        expires: '2016-03-06T06:36:09Z',
        allow_new_restaurants: true,
        created: '2016-03-06T06:36:09Z',
      })
      .returning('id')
      .then(function(pollid) {
        // return trx('poll_users')
        //   .insert({
        //     poll: id,
        //     user: body.users[0]
        //   });

        // var insertAllPollUsers = [];
        // for (var i = 0; i < users.length; i++) {
        //   // insertAllPollUsers.push(insertPollUser(users[i], id));
        //   insertAllPollUsers.push(trx.insert({
        //     user: users[i],
        //     poll: id,
        //     joined: '2016-03-06T06:36:09Z'
        //   }).into('poll_users'));
        // }

        // console.log(JSON.stringify(insertAllPollUsers));
        // console.log(insertAllPollUsers);

        console.log('IIIIID: ' + pollid);
        // return trx.select('*').from('poll').where('id', '=', id.toString());
        // console.log(id);

        // return trx.all(insertAllPollUsers);

        return Promise.map(users, function(userid) {
          console.log('kommer till Promise.map');
          return trx.insert({
            user_id: userid,
            poll_id: pollid[0],
            joined: '2016-03-06T06:36:09Z'
          }).into('poll_users');
        });
      });
  })
  .then(function(result) {
    console.log(result);
  })
  .catch(function(error) {
    console.log(error);
  });

console.log('yay');
