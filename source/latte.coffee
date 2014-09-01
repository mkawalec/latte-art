match bla,
  obj({a:1}) fun(supafn) obj({bla: 2}) -> code_1
  type(String) -> code_2
  
['a', 'b', rest] 

w = (testelem) ->
  (rightParam) ->
    (toEval) ->
      param = toEval.shift()
      if typeof testelem is 'function'
        if testelem(param)
          rightParam.call(@, toEval)
        else
          throw 'broken'
      else if Object.prototype.toString.call(testelem) is '[object Object]'
        if _.difference(_.keys(testelem), _.keys(param)).length is 0
          thisExtenstion = _.reduce testelem, ((acc, value, key) ->
            acc[value] = param[key]
            return acc
          ), {}
          rightParam.call(_.assign(@, thisExtension), toEval)
        else
          throw 'broken'
      else if Object.prototype.toString.call(testelem) is '[object RegExp]'
        if testelem.test param
          rightParam.call(@, toEval)
        else
          throw 'broken'
      else
        throw 'unsupported arg'

