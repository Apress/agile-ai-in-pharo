Class {
	#name : #MNWorld,
	#superclass : #Object,
	#instVars : [
		'map',
		'mario',
		'view',
		'monsters',
		'isGameRunning',
		'random'
	],
	#category : #MiniMario
}

{ #category : #'as yet unclassified' }
MNWorld >> addBrick: position [
	"Add a brick to a position"
	(self isInMap: position)
		ifTrue: [ self cellAt: position put: 1 ]
]

{ #category : #'as yet unclassified' }
MNWorld >> addMonster: aMonster [
	"Add a monster to the world"
	monsters add: aMonster.
	aMonster game: self.
]

{ #category : #'as yet unclassified' }
MNWorld >> addPlatform: position [
	"A platform is horizontal and made of 5 bricks"
	-2 to: 2 do: [ :i |
		self addBrick: position + (i @ 0) ]
]

{ #category : #'as yet unclassified' }
MNWorld >> addTube: positionX [
	"Add a tube at a given position in the map"
 	| indexY |
	indexY := self size y - 1.
	3 timesRepeat: [ 
		self addTubeCell: positionX @ indexY.
		indexY := indexY - 1 ].
]

{ #category : #'as yet unclassified' }
MNWorld >> addTubeCell: position [
	"Add a cell representing a tube at a given position"
	(self isInMap: position)
		ifTrue: [ self cellAt: position put: 2 ]
]

{ #category : #'as yet unclassified' }
MNWorld >> beat [
	"The world beat performs a beat on each monster and on Mario"
	isGameRunning ifFalse: [ ^ self ].
	monsters do: #beat.
	mario beat.
	self refreshView
]

{ #category : #'as yet unclassified' }
MNWorld >> cellAt: aPoint put: value [
	"Set the value of a particular cell"
	^ map at: aPoint y at: aPoint x put: value
]

{ #category : #'as yet unclassified' }
MNWorld >> gameOver [
	"End the game"
	isGameRunning := false.
	view ifNil: [ ^ self ].
	view add: ((RTLabel new color: Color red; text: 'GAME OVER') element translateBy: 0 @ -100)
]

{ #category : #'as yet unclassified' }
MNWorld >> generateMap [
	"Randomly generate the map used in the world"
	map := Array2D rows: self size y columns: self size x element: 0.
	1 to: self size x do: [ :x | self addBrick: (x @ self size y); addBrick: (x @ 1) ].
	1 to: self size y do: [ :y | self addBrick: (1 @ y); addBrick: (self size x @ y) ].

	"The map has 80 platforms..."
	80 timesRepeat: [ 
		self addPlatform: (random nextInt: self size x) @ (random nextInt: self size y) ].
	
	"... and 30 tubes"
	30 timesRepeat: [ self addTube: (random nextInt: self size x) ]
]

{ #category : #'as yet unclassified' }
MNWorld >> generateUI [
	"Build the game user interface"
	| e upperBounds lowerBounds cellSizeInPixel |
	"Size of each cell"
	cellSizeInPixel := 25.

	"Create the visual representation of cells"	
	view := RTView new.
	upperBounds := self windowSize // 2.
	lowerBounds := upperBounds negated.
	lowerBounds to: upperBounds do: [ :x |
		lowerBounds to: upperBounds do: [ :y |
			e := RTBox new size: cellSizeInPixel + 1; elementOn: x @ y.
			view add: e.
			e translateTo: (x @ y) * cellSizeInPixel ] ].
	
	"Define the actions to be taken when keys are pressed"
	view when: TRKeyDown do: [ :evt | 
		"Key D"
		evt keyValue = 100 ifTrue: [ mario moveRight ].

		"Key A"
		evt keyValue = 97 ifTrue: [ mario moveLeft ].

		"Key W"
		evt keyValue = 119 ifTrue: [ mario jump ] ].
	
	"A beat is performed at each update of the UI"
	view addAnimation: (RTActiveAnimation new intervalInMilliseconds: 30; blockToExecute: [ self beat ]).
	self refreshView.
]

{ #category : #'as yet unclassified' }
MNWorld >> getCellAt: aPoint [
	"Return the value of a particular cell"
	^ map at: aPoint y at: aPoint x
]

{ #category : #'as yet unclassified' }
MNWorld >> initialize [
	super initialize.
	self initializeMario.
	self seed: 42.
	self initializeMonsters.
	isGameRunning := true
]

{ #category : #'as yet unclassified' }
MNWorld >> initializeMario [
	"Create a Mario object"
	mario := MNMario new.
	mario translateTo: 2 @ 2.
	mario game: self.
]

{ #category : #'as yet unclassified' }
MNWorld >> initializeMonsters [
	"Add a number of monsters"
	monsters := OrderedCollection new.
	10 timesRepeat: [ 
		| m |
		m := MNMonster new translateTo: (random nextInt: self size x) @ 2.
		self addMonster: m ]
]

{ #category : #'as yet unclassified' }
MNWorld >> isInMap: position [
	"Return true if the position is within the map"
	^ (1 @ 1 extent: self size) containsPoint: position
]

{ #category : #'as yet unclassified' }
MNWorld >> mario [
	"Return the Mario character"
	^ mario
]

{ #category : #'as yet unclassified' }
MNWorld >> mario: aMario [
	"Set Mario in the game"
	mario := aMario.
	mario game: self.
	mario translateTo: 2 @ 2
]

{ #category : #'as yet unclassified' }
MNWorld >> monsters [
	"Return the list of monsters living in the world"
	^ monsters
]

{ #category : #'as yet unclassified' }
MNWorld >> open [
	"Open the UI"
	self inspect.
	self generateUI.
	^ view open
]

{ #category : #'as yet unclassified' }
MNWorld >> refreshView [
	"Research the UI"
	| p t color |
	view isNil ifTrue: [ ^ self ].
	isGameRunning ifFalse: [ ^ self ].

	p := mario position.
	view elements doWithIndex: [ :e :index |
		t := p + e model.
		"Empty cells are blue
		 Platform cells are brown
		 Tube cells are green
		 Cells outside the map are black"
		(self isInMap: t) 
			ifTrue: [ 
				(self getCellAt: t) = 0 ifTrue: [ color := Color blue ].
				(self getCellAt: t) = 1 ifTrue: [ color := Color brown ].
				(self getCellAt: t) = 2 ifTrue: [ color := Color green ] ]	
			ifFalse: [ color := Color black ].
		
		"Mario is red"
		e model = (0 @ 0) ifTrue: [ color := Color red ].
		e trachelShape color: color ].

	monsters do: [ :m |
		t := m position - p.
		"Only monster that are within the window frame are rendered"
		t x abs < self windowSize ifTrue: [ 
			| cell |
			cell := view elements elementFromModel: t.
			"Monster are orange"
			cell notNil ifTrue: [ cell trachelShape color: Color orange ] ]. 
	].
	view signalUpdate.
]

{ #category : #'as yet unclassified' }
MNWorld >> seed: aNumber [
	"Create a random number generator with a particular seed"
	random := Random seed: aNumber.
	self generateMap.
]

{ #category : #'as yet unclassified' }
MNWorld >> showCompleteMap [
	"Show the complete map"
	| v cellSizeInPixel color e |
	v := RTView new.
	v @ RTDraggableView.
	cellSizeInPixel := 4.
	1 to: self size x do: [ :x |
		1 to: self size y do: [ :y |
			color := Color black.
			(self getCellAt: x @ y) = 0 ifTrue: [ color := Color blue ].
			(self getCellAt: x @ y) = 1 ifTrue: [ color := Color brown ].
			(self getCellAt: x @ y) = 2 ifTrue: [ color := Color green ].

			e := RTBox new size: cellSizeInPixel + 1; color: color; elementOn: x @ y.
			v add: e.
			e translateTo: (x @ y) * cellSizeInPixel ] ].
	v open
]

{ #category : #'as yet unclassified' }
MNWorld >> size [
	"Return the size of the map"
	^ 300 @ 10
]

{ #category : #'as yet unclassified' }
MNWorld >> whatMarioSees [
	"Return the values of the visible cells"
	| result p t upperBounds lowerBounds |
	result := OrderedCollection new.
	p := mario position.
	
	upperBounds := self windowSize // 2.
	lowerBounds := upperBounds negated.
	lowerBounds to: upperBounds do: [ :x |
		lowerBounds to: upperBounds do: [ :y |
			t := p + (x @ y).
			(self isInMap: t) 
			ifTrue: [ result add: (self getCellAt: t) ]
			ifFalse: [ result add: 1 ] ] ].
	^ result
]

{ #category : #'as yet unclassified' }
MNWorld >> windowSize [
	"Number of pixels of a window frame side"
	^ 11
]
