

**Array workarrounds**

* If Synth is passed an array makes an array of synths that behave like one, freeing it frees all. DelegatorArray

* Somehow let all elements of an array be multiplied by a number, maybe if the Numeric multiplies the Array, eg:

  2 * [1,2] == [2,4] and 2 * [1,2] == c[2,4] and ChannelArray.new(2,4) # => true (DONE)

* Maybe the result of a multichannel Ugen could be an instance of Array with binary operators overriden, eg:

    mc = SinOsc.ar [400,402]
    mc * 0.5 == c(SinOsc.ar(400) * 0.5, SinOsc.ar(402) * 0.5) # => true

* "Literal" for ChannelArray c[] or c()