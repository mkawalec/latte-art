describe "a very simple test", ->
  it "should pass", ->
    expect(1).to.equal 1

describe 'wrapper tests (function)', ->
  it 'should call the function', ->
    spy = sinon.stub().returns true
    wrapper = w(spy)(-> true)([true], [true])
    expect(spy.called).to.equal true
