Class {
	#name : #NESpecies,
	#superclass : #Object,
	#instVars : [
		'individuals',
		'id'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NESpecies >> averageFitness [
	"Return the average fitness of the species"
	^ (self individuals collect: #fitness) average
]

{ #category : #'as yet unclassified' }
NESpecies >> gtInspectorListOfIndividualIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite list
		title: 'Individuals';
		display: individuals
]

{ #category : #'as yet unclassified' }
NESpecies >> id [
	"Return the identifier of the species"
	^ id
]

{ #category : #'as yet unclassified' }
NESpecies >> id: anInteger [
	"Set the species identifier"
	id := anInteger
]

{ #category : #'as yet unclassified' }
NESpecies >> individuals [
	"Return the individuals composing the species"
	^ individuals
]

{ #category : #'as yet unclassified' }
NESpecies >> individuals: someIndividuals [
	"Set the individuals of the species"
	individuals := someIndividuals
]

{ #category : #'as yet unclassified' }
NESpecies >> maxFitness [
	"Return the max fitness of the species individuals"
	^ (self individuals collect: #fitness) max
]

{ #category : #'as yet unclassified' }
NESpecies >> numberOfIndividuals [
	"Return the size of the species"
	^ individuals size
]
