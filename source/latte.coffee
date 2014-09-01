match bla,
  obj({a:1}) fun(supafn) obj({bla: 2}) -> code_1
  type(String) -> code_2
  
call = (fn, self, passed, allParams) ->
  if fn.__stamp isnt 'internal'
    if passed.length > 0
      throw 'broken'
    else
      fn.call(self, allParams)
  else
    fn.call(self, passed, allParams)

w = (testelem) ->
  (rightParam) ->
    (toEval, allParams) ->
      param = toEval.shift()
      if typeof testelem is 'function'
        if testelem(param)
          call(rightParam, @, toEval, allParams)
        else
          throw 'broken'
      else if Object.prototype.toString.call(testelem) is '[object Object]'
        if _.difference(_.keys(testelem), _.keys(param)).length is 0
          thisExtenstion = _.reduce testelem, ((acc, value, key) ->
            acc[value] = param[key]
            return acc
          ), {}
          call(rightParam, _.assign(@, thisExtension), toEval, allParams)
        else
          throw 'broken'
      else if Object.prototype.toString.call(testelem) is '[object RegExp]'
        if testelem.test param
          call(rightParam, @, toEval, allParams)
        else
          throw 'broken'
      else if typeof testelem is 'string' or typeof testelem is 'number'
        if testelem is param
          call(rightParam, @, toEval, allParams)
        else
          throw 'broken'
      else
        throw 'unsupported arg'

w::__stamp = 'internal'
