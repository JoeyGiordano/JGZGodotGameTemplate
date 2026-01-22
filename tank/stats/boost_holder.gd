class_name BoostHolder

## Stores a stat boost and info about where it came from 
## Mostly only used by Stats Handler

var stat_boost : StatBoost
var source : Node
var has_source : bool = false
var boost_on : bool = true
var remove : bool = false

static func create_new(stat_boost_ : StatBoost) -> BoostHolder :
	var bh = BoostHolder.new()
	bh.stat_boost = stat_boost_
	return bh

static func create_with_source(stat_boost_ : StatBoost, source_ : Node) -> BoostHolder :
	var bh = BoostHolder.new()
	bh.stat_boost = stat_boost_
	bh.source = source_
	bh.has_source = true
	return bh
