Class {
	#name : #NEConnection,
	#superclass : #Object,
	#instVars : [
		'in',
		'out',
		'weight',
		'enabled',
		'innovationNumber'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEConnection >> in [
	"Return the index of the input node in the individual"
	^ in
]

{ #category : #'as yet unclassified' }
NEConnection >> in: anInteger [
	"Set the in node index"
	in := anInteger
]

{ #category : #'as yet unclassified' }
NEConnection >> innovationNumber [
	"Return the historical marker of the connection, the innovation number"
	^ innovationNumber
]

{ #category : #'as yet unclassified' }
NEConnection >> innovationNumber: anInteger [
	"Set the innovation number"
	innovationNumber := anInteger
]

{ #category : #'as yet unclassified' }
NEConnection >> isEnabled [
	"Return true if the connection is enabled"
	^ enabled 
]

{ #category : #'as yet unclassified' }
NEConnection >> makeDisabled [
	"Disable the connection"
	enabled := false
]

{ #category : #'as yet unclassified' }
NEConnection >> makeEnabled [
	"Enable the connection"
	enabled := true
]

{ #category : #'as yet unclassified' }
NEConnection >> out [
	"Return the index of the output node in the individual"
	^ out
]

{ #category : #'as yet unclassified' }
NEConnection >> out: anInteger [
	"Set the out node index"
	out := anInteger
]

{ #category : #'as yet unclassified' }
NEConnection >> weight [
	"Return the weight of the connection"
	^ weight
]

{ #category : #'as yet unclassified' }
NEConnection >> weight: aNumber [
	"Set the weight for the connection"
	weight := aNumber
]
