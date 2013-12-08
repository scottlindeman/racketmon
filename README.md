racketmon
=========

A wrapper for the Pokéapi <http://www.pokeapi.co/>.

Installation
------------

Clone this repository into any directory.

Then use raco:

    $ raco link -n "racketmon" "{Path to local racketmon directory here}"

Usage
-----

Making requests:

    (require racketmon)
    (get 'pokemon "bulbasaur")
