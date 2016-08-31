/**
 * Selectable containers management
 * */
(function () {
	'use strict';

	var byId = function (id) { return document.getElementById(id); },

		loadScripts = function (desc, callback) {
			var deps = [], key, idx = 0;

			for (key in desc) {
				deps.push(key);
			}

			(function _next() {
				var pid,
					name = deps[idx],
					script = document.createElement('script');

				script.type = 'text/javascript';
				script.src = desc[deps[idx]];

				pid = setInterval(function () {
					if (window[name]) {
						clearTimeout(pid);

						deps[idx++] = window[name];

						if (deps[idx]) {
							_next();
						} else {
							callback.apply(null, deps);
						}
					}
				}, 30);

				document.getElementsByTagName('head')[0].appendChild(script);
			})()
		},

		console = window.console;


	if (!console.log) {
		console.log = function () {
			alert([].join.apply(arguments, ' '));
		};
	}

	var srt1 = Sortable.create(byId('selected'), {
		group: "words",
		animation: 150,
		sort: true,
		onAdd: function (evt){ 
			console.log('onAdd.selected:', [evt.item, evt.from]); 
			if(evt.item.dataset.id === '4'){
				showTextGrid();
			}else if(evt.item.dataset.id === '7' || evt.item.dataset.id === '8'){
				showCheckBox();
			}
		},
		onUpdate: function (evt){ console.log('onUpdate.selected:', [evt.item, evt.from]); },
		onRemove: function (evt){ console.log('onRemove.selected:', [evt.item, evt.from]); },
		onStart:function(evt){ console.log('onStart.selected:', [evt.item, evt.from]);},
		onSort:function(evt){ console.log('onStart.selected:', [evt.item, evt.from]);},
		onEnd: function(evt){ console.log('onEnd.selected:', [evt.item, evt.from]);}
	});


	var srt2 = Sortable.create(byId('available'), {
		group: "words",
		animation: 150,
		sort: true,
		store: {
			get: function (sortable) {
				var myNodelist = document.getElementById('available').getElementsByTagName("li");
				var array = [];
				for (var i = 1; i <= myNodelist.length; i++) {
					array.push(i.toString());
				}
				return array;
			},
			set: function (sortable) {
			}
		},
		onAdd: function (evt){ 
			console.log('onAdd.available:', evt.item); 
			if(evt.item.dataset.id === '4'){
				hideTextGrid();
			}else if(evt.item.dataset.id === '7' || evt.item.dataset.id === '8'){
				var myNodelist = document.getElementById('selected').getElementsByTagName("li");
				var sixthModule = false;
				for (var i = 1; i < myNodelist.length; i++) {
					if(myNodelist[i].dataset.id === '7' || myNodelist[i].dataset.id === '8')
						sixthModule = true;
				}
				if(!sixthModule)
					hideCheckBox();
			}
		},
		onUpdate: function (evt){ console.log('onUpdate.available:', evt.item); },
		onRemove: function (evt){ console.log('onRemove.available:', evt.item); },
		onStart:function(evt){ console.log('onStart.available:', evt.item);},
		onEnd: function(evt){ console.log('onEnd.available:', evt.item);}
	});
})();

function hideTextGrid(){
	$('#textgridDiv').addClass("praat-hidden");
	$("#textGridFile").val("");
	$('#tgSel option[value=""]').attr('selected', true);
}

function showTextGrid(){
	$('#textgridDiv').removeClass("praat-hidden");
}

function hideCheckBox(){
	$('#checkboxDiv').addClass("praat-hidden");
	$("#justFinalTiers").attr('checked', false);
}

function showCheckBox(){
	$('#checkboxDiv').removeClass("praat-hidden");
}

/**
 * Execute scripts with given action
 * */
function run() {
	var myNodelist = document.getElementById('selected').getElementsByTagName("li");
	var text = "";
	for (i = 0; i <	myNodelist.length; i++) {
		if(i!=0)
			text += ",";
		text += myNodelist[i].dataset.id;
	}
	document.getElementById("scripsOrder").value = text;
	document.getElementById("runForm").submit();
}

/**
 * Set default modules 1
 * */
function def1(){
	var selectedChildren = document.getElementById('selected').getElementsByTagName("li");
	var availableChildren = document.getElementById('available').getElementsByTagName("li");
	var selectedParent = document.getElementById('selected');
	var availableParent = document.getElementById('available');

	moveAllElements(availableChildren, selectedParent);
	moveOnlyElement(selectedChildren, availableParent, "6");
	moveOnlyElement(selectedChildren, availableParent, "8");
	moveOnlyElement(selectedChildren, availableParent, "9");
	moveOnlyElement(selectedChildren, availableParent, "10");
	
	sort(selectedParent);
	showTextGrid();
	showCheckBox();
}

/**
 * Set default modules 2
 * */
function def2(){
	var selectedChildren = document.getElementById('selected').getElementsByTagName("li");
	var availableChildren = document.getElementById('available').getElementsByTagName("li");
	var selectedParent = document.getElementById('selected');
	var availableParent = document.getElementById('available');

	//moveAllElementsExcept(availableChildren, selectedParent, "4");
	moveAllElements(availableChildren, selectedParent);
	moveOnlyElement(selectedChildren, availableParent, "4");
	moveOnlyElement(selectedChildren, availableParent, "5");
	moveOnlyElement(selectedChildren, availableParent, "7");
	moveOnlyElement(selectedChildren, availableParent, "9");
	moveOnlyElement(selectedChildren, availableParent, "10");
	
	sort(selectedParent);
	hideTextGrid();
	showCheckBox();
}

/**
 * Move all element from one container to another
 * */
function moveAllElements(children, newParent){
	while (children.length > 0) {
	    newParent.appendChild(children[0]);
	}
}

/**
 * Move all element from one container to another except one
 * */
function moveAllElementsExcept(children, newParent, idToExclude){
	while (children.length > 1) {
		if(children[0].dataset.id === idToExclude){
			newParent.appendChild(children[1]);
		}else{
			newParent.appendChild(children[0]);
		}
	}
}

/**
 * Move one element from one container to another
 * */
function moveOnlyElement(children, newParent, idToMove){
	var found = false;
	var i = 0;
	while (!found && i < children.length) {
		if(children[i].dataset.id === idToMove){
			newParent.appendChild(children[i]);
			found = true;
		}
		i++;
	}
}

/**
 * Sorts the elements according to their ids.
 */
function sort (elementToSort) {
	var children = elementToSort.getElementsByTagName("li");
	var toLoc = children.length;
	
	while(toLoc > 0){
		var lowerPos = 0;
		var lowerVal = 1000;
		for(var i = 0; i < toLoc; i++){
			if(parseInt(children[i].dataset.id) < lowerVal){
				lowerVal = parseInt(children[i].dataset.id);
				lowerPos = i;
			}
		}
		var elected = children[lowerPos];
		
		elementToSort.removeChild(elected);
		elementToSort.appendChild(elected);
		
		toLoc--;
	}
}


/**
 * Check all required field are set
 * */
function checkAll(){
	var errorContainer = document.getElementById("errorMessage");
	var error = 0;
	if(document.getElementById('selected').getElementsByTagName("li").length == 0){
		errorContainer.innerHTML = "You must select at least one module tu run.";
		error = 1;
	}else if($("#audioFile").val() == "" && $("#audioSel").val() == ""){
		errorContainer.innerHTML = "No audio provided.";
		error = 1;
	}else if($("#textGridFile").is(":visible") && ($("#textGridFile").val() == "" && $("#tgSel").val() == "")){
		errorContainer.innerHTML = "No TextGrid provided.";
		error = 1;
	}else{
		errorContainer.innerHTML = "";
	}
	
	return !error;
}
