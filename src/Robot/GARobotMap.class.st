Class {
	#name : #GARobotMap,
	#superclass : #Object,
	#instVars : [
		'size',
		'content',
		'path',
		'random'
	],
	#category : #Robot
}

{ #category : #'as yet unclassified' }
GARobotMap >> drawRobotPath: aPath [
	"Draw the robot path"
	path := aPath.
	aPath do: [ :pos | self gridAt: pos put: #robot ]
]

{ #category : #'as yet unclassified' }
GARobotMap >> exitPosition [
	"The exit position, as a fixed position, 
	at the bottom right of the map"
	^ (size - 1) @ (size - 1)
]

{ #category : #'as yet unclassified' }
GARobotMap >> fillEntranceAndExitPoints [
	self gridAt: self initialPosition put: #start.
	self gridAt: self exitPosition put: #exit
]

{ #category : #'as yet unclassified' }
GARobotMap >> fillWithWalls: numberOfWalls [
	"Fill the map with a given number of walls"
	| offsets |
	numberOfWalls timesRepeat: [ 
		| x y |
		x := self rand: size.
		y := self rand: size.
		
		offsets := (self rand: 2) = 1 
			ifTrue: [ { 1 @ 0 . -1 @ 0 } ] 
			ifFalse: [ { 0 @ -1 . 0 @ -1 } ].
		self gridAt: x @ y put: #wall.
		self gridAt: (x @ y) + offsets first put: #wall.
		self gridAt: (x @ y) + offsets second put: #wall.
	].
	self fillEntranceAndExitPoints.

	"Fill the map border"
	1 to: size do: [ :i | 
		self gridAt: i @ 1 put: #wall. 
		self gridAt: 1 @ i put: #wall.
		self gridAt: size @ i put: #wall.
		self gridAt: i @ size put: #wall ] 
]

{ #category : #'as yet unclassified' }
GARobotMap >> gridAt: aPoint [
	"Return the content of a map at a given location.
	Everything outside the map is empty."
	(self includesPoint: aPoint) ifFalse: [ ^ #empty ].
	^ (content at: aPoint y) at: aPoint x
]

{ #category : #'as yet unclassified' }
GARobotMap >> gridAt: aPoint put: value [
	"Modify the map content.
	value is a symbol: #empty, #wall, #start, #exit, #robot"
	(self includesPoint: aPoint)
		ifFalse: [ ^ self ].
	^ (content at: aPoint y) at: aPoint x put: value
]

{ #category : #'as yet unclassified' }
GARobotMap >> includesPoint: aPoint [
	"Answer whether a point is within the map"
	^ (1 @ 1 extent: size @ size) containsPoint: aPoint
]

{ #category : #'as yet unclassified' }
GARobotMap >> initialPosition [
	"The starting position is at the top left of the map"
	^ 2 @ 2
]

{ #category : #'as yet unclassified' }
GARobotMap >> initialize [
	super initialize.
	random := Random seed: 42.
	self size: 30.
]

{ #category : #'as yet unclassified' }
GARobotMap >> open [
	"Build and open the visual representation of the map"
	| v colors shape |
	colors := { #empty -> Color white . #wall -> Color brown . 
		#start -> Color red . #exit -> Color green . 
		#robot -> Color yellow } asDictionary.

	v := RTView new.
	shape := RTBox new size: 10; color: [ :c | colors at: c ].
	content do: [ :line | 
		v addAll: (shape elementsOn: line) @ RTPopup
	].
	RTGridLayout new gapSize: 0; lineItemsCount: size; on: v elements.
	v add: (RTLabel elementOn: path size asString, ' steps').
	TRConstraint move: v elements last below: v elements allButLast.
	^ v open
]

{ #category : #'as yet unclassified' }
GARobotMap >> rand: anInteger [
	"Return a new random number"
	^ random nextInt: anInteger
]

{ #category : #'as yet unclassified' }
GARobotMap >> size: aSize [
	"Create a map of a given size and fills it with #empty"
	size := aSize.
	content := Array new: aSize.
	1 to: size do: [ :i | 
		content at: i put: (Array new: aSize withAll: #empty) ].
	self fillEntranceAndExitPoints
]
