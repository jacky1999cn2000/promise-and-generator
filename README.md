# promise-and-generator

这里的代码主要是为了说明co和co-request(基于generator promise)的用法

generator: https://www.npmjs.com/package/co-request
co: https://www.npmjs.com/package/co
co-request: https://www.npmjs.com/package/co-request

简单地说，generator提供了让异步程序停下来的机制，而co则利用这个机制，为异步编程提供了一个便捷的流程控制架构；
co-request是co架构里对request npm的包装。

这里的4个文件是从sailsjs project中摘取的

Challenge.js - model
ChallengeController.js - controller
ChallengeService.js - service
runLocal.sh - bash

最简单的例子就是：

```
let result = yield request(params);
或
let result = yield Model.verb(entry);
或
let result = yield Promise.resolve(value);
```

程序执行到这里的时候会停下来，等待异步方法返回(可以是网络访问的request,可以是sailsjs的数据库操作,事实上,支持任何异步并返回Promise的方法)

co有两种返回模式 - 1.返回Promise(被其他的co函数调用) 2.返回最终数值

第一种模式: 整个函数有一个返回值 - return co(function* (){...}); 函数里面的代码也有一个返回值。

简单地说，这个函数的返回值为Promise(resObj)

```
makeRequest: function(nitroParams, options){
  return co(function* (){
    let requestParams = ChallengeService.getRequestParams(nitroParams, options);
    let response = yield request(requestParams);
    let resObj = JSON.parse(response.body);
    return resObj;
  });
}
```

第二种模式: 在co(function* (){})函数中依然可以通过yield来调用返回Promise的异步函数(比如makeRequest),
但最终用.then(function(){})来对值进行处理和返回，用.catch(function(){})来捕获异常

```
destroy: function(req, res){
  co(function* () {
    console.log('*** destroy challenge *** \n');
    var options = {};
    var result = {};

    //get admin session key
    let sessionKey_result = yield ChallengeService.loginAdmin(options)
    if(sessionKey_result.status == 'error') return sessionKey_result;
    options.sessionKey = sessionKey_result.sessionKey;

    //get record from db
    let record = yield Challenge.findOne({id:req.params.id});
    if(typeof record === 'undefined'){
      result.status = 'error';
      result.statusMessage = 'Can\'t find challenge in database.';
      return result;
    }

    //delete challenges from nitro
    let delete_result1 = yield ChallengeService.deleteChallenge(options, record.nitroId[0]);
    if(delete_result1.status == 'error') return delete_result1;

    let delete_result2 = yield ChallengeService.deleteChallenge(options, record.nitroId[1]);
    if(delete_result2.status == 'error') return delete_result2;

    //delete record from db
    let delete_db_result = yield Challenge.destroy({id:req.params.id});

    //prepare return data
    result.status = 'ok';
    result.deletedChallengeId = [];
    if(delete_result1.deletedChallengeId != ''){
      result.deletedChallengeId.push(delete_result1.deletedChallengeId);
    }
    if(delete_result2.deletedChallengeId != ''){
      result.deletedChallengeId.push(delete_result2.deletedChallengeId);
    }

    return result;
  })
  .then(function(result){
    res.send(result);
  })
  .catch(function(err) {
    console.log('*** catch ***');
    console.log(err);
    var error = {};
    error.status = 'error';
    error.statusMessage = err;
    res.send(500, error);
  });
}
```
