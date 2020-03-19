Class {
	#name : #NECrossoverOperation,
	#superclass : #Object,
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NECrossoverOperation >> performOn: i1 and: i2 [
	"Return a child individual that is the result of a crossover between individuals i1 and i2"
	"The method ASSUMES that the fitness of i1 is higher than the one of i2"

	| newConnections indexI1 indexI2 shouldIterate newNodes |
	"newNodes are the nodes of the child individual. 
	 It is simply a copy of the nodes of the best individual, i1."
	newNodes := i1 nodes collect: #copy.

	"newConnections are the connections of the child individual"
	newConnections := OrderedCollection new.

	"If any individuals has no connection, then we create a new individual with no connection"
	(i1 connections notEmpty and: [ i2 connections notEmpty ]) 
		ifFalse: [ ^ NEIndividual new nodes: newNodes; connections: newConnections; random: i1 random ].

	"We initialize some temporary variables"
	indexI1 := 1.
	indexI2 := 1.
	shouldIterate := true.

	"The iteration loop"
	[ shouldIterate ] whileTrue: [ 
		| c1 c2 |
		indexI1 := indexI1 min: i1 numberOfConnections.
		indexI2 := indexI2 min: i2 numberOfConnections.
		c1 := i1 connections at: indexI1.
		c2 := i2 connections at: indexI2.
		c1 innovationNumber = c2 innovationNumber
			ifTrue: [ 
				newConnections add: (i1 random next > 0.5 ifTrue: [ c1 ] ifFalse: [ c2 ]) copy.
				indexI1 := indexI1 + 1.
				indexI2 := indexI2 + 1. ]
			ifFalse: [ shouldIterate := false ].

		(indexI1 >= i1 numberOfConnections and: [ indexI2 >= i2 numberOfConnections ])
			ifTrue: [ shouldIterate := false ]
	].
	"We consider the remainder connection from the best individual"
	newConnections addAll: ((i1 connections allButFirst: indexI1 - 1) collect: #copy).

	"A new individual is returned"
	^ NEIndividual new nodes: newNodes; connections: newConnections; random: i1 random
]
