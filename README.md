racketmon
=========

A wrapper for the Pokéapi <http://www.pokeapi.co/>.

Installation
------------

Clone this repository into any directory.

Then use raco:

    $ cd {racketmon directory}
    $ raco pkg install --link "{Full path to local racketmon directory here}"

Usage
-----

Making requests:

    >>>(require racketmon/pokeapi)
    >>>(define bulbasaur (get 'pokemon #:name "bulbasaur"))
    >>>(pokemon-attack bulbasaur)
    49

Getting other resources:

    >>>(has-move? bulbasaur "leech-seed")
    #t
    >>>(define leech-seed (get-move bulbasaur "leech-seed"))
    >>>(move-name leech-seed)
    "Leech-seed"

Alternatively,

    >>>(define leech-seed-by-id (get 'move #:id 73))
    >>>(move-name leech-seed-by-id)
    "Leech-seed"
    
All current resources on the pokeapi can be called through the get function through using their ids.
    
