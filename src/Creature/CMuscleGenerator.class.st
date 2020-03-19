Class {
	#name : #CMuscleGenerator,
	#superclass : #Object,
	#instVars : [
		'random',
		'minStrength',
		'deltaStrength',
		'minLength',
		'deltaLength',
		'minTime',
		'deltaTime'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CMuscleGenerator >> createMuscleFrom: aNode to: anotherNode [
	"Return a new muscle connecting two nodes"
	| m |
	m := CMuscle new.
	m node1: aNode.
	m node2: anotherNode.
	m length1: self generateLength.
	m length2: self generateLength.
	m time1: self generateTime.
	m time2: self generateTime.
	m strength: self generateStrength.
	^ m
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> deltaLength: anInteger [
	deltaLength := anInteger
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> deltaStrength: anInteger [
	deltaStrength := anInteger
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> deltaTime: anInteger [
	deltaTime := anInteger
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> generateLength [
	"Return a length within the specified range"
	^ minLength + (random nextInt: deltaLength)
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> generateStrength [
	"Return a strength within the specified range"
	^ random next * deltaStrength + minStrength
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> generateTime [
	"Return a time within the specified range"
	^ (random nextInt: deltaTime) + minTime
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> initialize [
	super initialize.
	self resetSeed.	
	minLength := 10.
	deltaLength := 30.
	minTime := 4.
	deltaTime := 200.
	minStrength := 1.
	deltaStrength := 3
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> materialize: values inMuscle: aMuscle [
	"Configure the provided muscle with some values"
	aMuscle length1: values first.
	aMuscle length2: values second.
	aMuscle strength: values third.
	aMuscle time1: values fourth.
	aMuscle time2: values fifth
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> minLength: anInteger [
	"Set the minimum value a muscle length may have"
	minLength := anInteger
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> minStrength: anInteger [
	"Set the minimum value a muscle strength can have"
	minStrength := anInteger
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> minTime: anInteger [
	"Set the minimum value a muscle time threshold can be"
	minTime := anInteger
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> random: randomNumberGenerator [
	"Set the random number generated used to produce muscles"
	random := randomNumberGenerator
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> resetSeed [
	random := Random seed: 42.
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> serializeMuscle: aMuscle [
	"Return an array describing the muscle provided as argument"
	^ Array
		with: aMuscle length1
		with: aMuscle length2
		with: aMuscle strength
		with: aMuscle time1
		with: aMuscle time2
]

{ #category : #'as yet unclassified' }
CMuscleGenerator >> valueForIndex: anIndex [
	"Produce a value for a given index of an individual chromosome. 
	This method is used to generate a gene in the genetic algorithm"
	| i |
	i := (anIndex - 1) % 5. "% refers to modulo"
	i = 0 ifTrue: [ ^ self generateLength ].
	i = 1 ifTrue: [ ^ self generateLength ].
	i = 2 ifTrue: [ ^ self generateStrength ].
	i = 3 ifTrue: [ ^ self generateTime ].
	i = 4 ifTrue: [ ^ self generateTime ].
	self error: 'Should not be here'
]
