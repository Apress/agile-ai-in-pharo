Class {
	#name : #NESpeciation,
	#superclass : #Object,
	#instVars : [
		'frameSize',
		'groups'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NESpeciation >> frameSize: anInteger [
	"Set the window frame size hyperparameter"
	frameSize := anInteger
]

{ #category : #'as yet unclassified' }
NESpeciation >> groups [
	"Return the groups of species. Each group being an instance of NESpecies"
	^ groups
]

{ #category : #'as yet unclassified' }
NESpeciation >> initialize [
	super initialize.
	frameSize := 3.
]

{ #category : #'as yet unclassified' }
NESpeciation >> numberOfSpecies [
	"Return the number of species produced by the speciation"
	^ groups size
]

{ #category : #'as yet unclassified' }
NESpeciation >> process: someIndividuals [
	"Run the speciation algorithm for a given collection of individuals.
	 This method takes as argument a collection of collection of innovation numbers"
	| g |
	g := someIndividuals groupedBy: [ :individual | 
		| seq |
		seq := individual innovationNumberSequence.
		seq size < 2 
			ifTrue: [ seq first ]
			ifFalse: [ (seq last: (frameSize min: seq size - 1)) first ] ]. 

	"Bind each species to its corresponding individuals"
	groups := g associations collect: [ :assoc | NESpecies new individuals: assoc value; id: assoc key ].
	groups do: [ :aSpecies |
		aSpecies individuals do: [ :i | i species: aSpecies ] ]
]

{ #category : #'as yet unclassified' }
NESpeciation >> visualize [
	"Visualize groups of individual"
	| b legendBuilder |
	b := RTMondrian new.
	b shape box size: [ :s | s individuals size ].
	b nodes: (self groups reverseSortedAs: #maxFitness).
	b layout grid.
	b normalizer normalizeColor: #maxFitness.
	b build.
	
	legendBuilder := RTLegendBuilder new.
	legendBuilder view: b view.
	legendBuilder addText: 'Species visualization'.
	legendBuilder addText: 'Box size = Species size'.
	legendBuilder addColorFadingFrom: Color gray to: Color red text: 'Max fitness'.
	legendBuilder build.
	^ b view
]
