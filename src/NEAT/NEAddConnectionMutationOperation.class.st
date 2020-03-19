Class {
	#name : #NEAddConnectionMutationOperation,
	#superclass : #NEAbstractStructuralMutationOperation,
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEAddConnectionMutationOperation >> findMissingConnectionIn: anIndividual nbTry: nbTry [
	"Return an array containing two nodes. 
	 Only a finite number of tries are made to find those nodes."
	| node1 node2 |
	"If we made our tries, then we return nil meaning that no connections can be made"
	nbTry = 0 ifTrue: [ ^ nil ].

	"The connection goes from node1 to node2. node1 cannot be an output node therefore"
	node1 := (anIndividual nodes reject: #isOutput) atRandom: random.

	"Similarly, node2 cannot be an input node."
	node2 := (anIndividual nodes reject: #isInput) atRandom: random.

	"Is there already a connection from node1 to node2?"
	(anIndividual connections anySatisfy: [ :c |
		(c in = node1 id and: [ c out = node2 id ]) ]) ifTrue: [ 
			"If yes, then we iterate once more"
			^ self findMissingConnectionIn: anIndividual nbTry: (nbTry - 1) ]. 

	"We check if there is no path going from node2 to node1. 
	 Adding a connection should not introduce a cycle"
	(self is: node1 accessibleFrom: node2 in: anIndividual)
		ifTrue: [ ^ self findMissingConnectionIn: anIndividual nbTry: (nbTry - 1) ].

	^ { node1 id . node2 id }
]

{ #category : #'as yet unclassified' }
NEAddConnectionMutationOperation >> is: node1 accessibleFrom: node2 in: anIndividual [
	"Is there a path going from node2 to node1?"
	anIndividual buildNetwork.
	^ self privateIs: node1 accessibleFrom: node2
]

{ #category : #'as yet unclassified' }
NEAddConnectionMutationOperation >> on: anIndividual [
	"Add a connection between two nodes to an individual"
	| array |
	"Find two nodes in which we can add a connection. No more 
	 than 5 tries are made"
	array := self findMissingConnectionIn: anIndividual nbTry: 5.

	"We did not find a solution, so we merely exit. There is not much we can do"
	array ifNil: [ ^ self ].

	"Else, we add the connection"
	anIndividual
		addConnection:
			(NEConnection new
				in: array first;
				out: array second;
				weight: self randomWeight;
				makeEnabled;
				innovationNumber: InnovationNumber)
]

{ #category : #'as yet unclassified' }
NEAddConnectionMutationOperation >> privateIs: node1 accessibleFrom: node2 [
	"Recursively look for a path from node2 to node1"
	node1 == node2 ifTrue: [ ^ true ].
	node2 connectedNodes do: [ :n |
		node1 == n ifTrue: [ ^ true ].
		(self privateIs: node1 accessibleFrom: n) ifTrue: [ ^ true ] ].
	^ false
]
