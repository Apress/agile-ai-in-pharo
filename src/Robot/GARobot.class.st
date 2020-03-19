Class {
	#name : #GARobot,
	#superclass : #Object,
	#instVars : [
		'position',
		'map'
	],
	#category : #Robot
}

{ #category : #'as yet unclassified' }
GARobot >> followOrders: orders [
	"Make the robot follow the orders. 
	 Return the path taken by the robot"
	| delta possiblePosition path |
	delta := { $N -> (0 @ -1) . $S -> (0 @ 1) . 
		   $W -> (-1 @ 0) . $E -> (1 @ 0) } asDictionary.
	path := OrderedCollection new.
	path add: map initialPosition.
	self position: map initialPosition.
	orders
		do: [ :direction | 
			possiblePosition := position + (delta at: direction).
			
			"If we found the exit, then we return and 
			make no further progresses"
			possiblePosition == map exitPosition ifTrue: [ ^ path ].
			
			"If there is no wall, then we effectively do the move"
			(map gridAt: possiblePosition) ~= #wall ifTrue: [ 
				position := possiblePosition.
				path add: position ] ].
	^ path
]

{ #category : #'as yet unclassified' }
GARobot >> map: aMap [
	"Set the map where the robot lives in"
	map := aMap
]

{ #category : #'as yet unclassified' }
GARobot >> position [
	"Return the position of the robot"
	^ position
]

{ #category : #'as yet unclassified' }
GARobot >> position: aPoint [
	"Set the position of the robot"
	position := aPoint
]
