Class {
	#name : #CMuscle,
	#superclass : #CConnection,
	#instVars : [
		'time',
		'time1',
		'time2',
		'length1',
		'length2',
		'strength',
		'color'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CMuscle >> beat [
	"Beating a muscle increases its timer"
	time := time + 1.
	time = self maxTime ifTrue: [ time := 0 ].
]

{ #category : #'as yet unclassified' }
CMuscle >> color: aColor [
	"Set the color of the muscle"
	color := aColor
]

{ #category : #'as yet unclassified' }
CMuscle >> createElement [
	"A muscle is a transparent line between the two nodes"
	element := RTLine new color: (color alpha: 0.3); width: 5; 
				edgeFrom: node1 element to: node2 element
]

{ #category : #'as yet unclassified' }
CMuscle >> initialize [
	super initialize.
	time := 0.
	color := Color red.
]

{ #category : #'as yet unclassified' }
CMuscle >> length [
	"Maybe rename it to ideal length"
	^ time < self minTime
		ifTrue: [ length1 ]
		ifFalse: [ length2 ]
]

{ #category : #'as yet unclassified' }
CMuscle >> length1 [
	"Length of a muscle at the beginning of a cycle"
	^ length1
]

{ #category : #'as yet unclassified' }
CMuscle >> length1: aLengthAsInteger [
	"Set the muscle length at the beginning of a cycle"
	length1 := aLengthAsInteger
]

{ #category : #'as yet unclassified' }
CMuscle >> length2 [
	"Length of a muscle at the end of a cycle"
	^ length2
]

{ #category : #'as yet unclassified' }
CMuscle >> length2: aLengthAsInteger [
	"Set the muscle length at the end of a cycle"
	length2 := aLengthAsInteger
]

{ #category : #'as yet unclassified' }
CMuscle >> maxTime [
	"Return the cycle length"
	^ time1 max: time2
]

{ #category : #'as yet unclassified' }
CMuscle >> minTime [
	"Return the timer threshold between to switch between length1 and length2"
	^ time1 min: time2
]

{ #category : #'as yet unclassified' }
CMuscle >> strength [
	"Return the strength of the muscle"
	^ strength
]

{ #category : #'as yet unclassified' }
CMuscle >> strength: strengthAsFloat [
	"Set the strength that is applied to the extremities"
	strength := strengthAsFloat
]

{ #category : #'as yet unclassified' }
CMuscle >> time1 [
	^ time1
]

{ #category : #'as yet unclassified' }
CMuscle >> time1: anInteger [
	time1 := anInteger
]

{ #category : #'as yet unclassified' }
CMuscle >> time2 [
	^ time2
]

{ #category : #'as yet unclassified' }
CMuscle >> time2: anInteger [
	time2 := anInteger
]

{ #category : #'as yet unclassified' }
CMuscle >> usesNodes: twoNodes [
	"The method accepts an array of two nodes as argument.
	Return true if the muscle connects the two nodes."
	^ (node1 == twoNodes first and: [ node2 == twoNodes second ]) or:  
		[ node1 == twoNodes second and: [ node2 == twoNodes first ] ]
]
