match bla,
  obj({a:1}) fun(supafn) obj({bla: 2}) -> code_1
  type(String) -> code_2
  
call = (fn, self, passed, allParams) ->
  if fn.__stamp isnt 'internal'
    if passed.length > 0
      throw
        msg: 'There are arguments left'
        type: 'ValidationError'
    else
      fn.call(self, allParams)
  else
    fn.call(self, passed, allParams)

w = (testelem) ->
  (rightParam) ->
    afterWrapping = (toEval, allParams) ->
      param = toEval.shift()

      if typeof testelem is 'function'
        if testelem(param)
          call(rightParam, @, toEval, allParams)
        else
          throw
            msg: "Function didn't match on parameter #{param}"
            type: 'ValidationError'

      else if Object.prototype.toString.call(testelem) is '[object Object]'
        notFoundKeys = _.difference(_.keys(testelem), _.keys(param))
        if notFoundKeys.length is 0
          thisExtenstion = _.reduce testelem, ((acc, value, key) ->
            acc[value] = param[key]
            return acc
          ), {}
          call(rightParam, _.assign(@, thisExtension), toEval, allParams)
        else
          throw
            msg: "Object key matching failed, with the 
                  following keys not found: #{notFoundKeys}
                  on parameter #{param}"
            type: 'ValidationError'

      else if Object.prototype.toString.call(testelem) is '[object RegExp]'
        if testelem.test param
          call(rightParam, @, toEval, allParams)
        else
          throw
            msg: "Regex validation failed on parameter #{param}"
            type: 'ValidationError'

      else if typeof testelem is 'string' or typeof testelem is 'number'
        if testelem is param
          call(rightParam, @, toEval, allParams)
        else
          throw
            msg: "The parameter #{param} is not equal to pattern #{testelem}"
            type: 'ValidationError'

      else if testelem is undefined
        call(rightParam, @, toEval, allParams)
      else
        throw
          msg: "The test parameter #{testelem} is of a wrong type"
          type: 'ValidationError'

    afterWrapping::__stamp = 'internal'
    afterWrapping
