# Apress Source Code

This repository accompanies [*Agile Artificial Intelligence in Pharo*](https://www.apress.com/9781484253830) by Alexandre Bergel (Apress, 2020).

[comment]: #cover
![Cover image](img/9781484253830.jpg)

The book provides a complete implementation of a number of complex algorithms. Download the files as a zip using the green button, or clone the repository to your machine using Git.

## How to load it?

The provided code was designed for [Pharo](http://pharo.org) and it works Pharo 8 and Pharo 9. Open a playground and execute the instructions:

```Smalltalk
Metacello new
    baseline: 'AgileArtificialIntelligence';
    repository: 'github://Apress/agile-ai-in-pharo/src';
    load.
```

## Content

The repository provides the complete implementation of:

- Neural network library
- Matrix library
- Genetic algorithm
- Zoomorphic creature
- NEAT neuroevolution algorithm
- Mario-like game 

## Releases

Release v1.0 corresponds to the code in the published book, without corrections or updates.

## Contributions

See the file [Contributing.md](Contributing.md) for more information on how you can contribute to this repository.
