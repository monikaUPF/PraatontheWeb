/**
 * Execute scripts with given action
 * */
function run() {
	document.getElementById("runForm").submit();
}

/**
 * Check all required field are set
 * */
function checkAll(){
	var errorContainer = document.getElementById("errorMessage");
	var error = 0;
	if($("#textGridFile").val() == "" && $("#tgSel").val() == ""){
		errorContainer.innerHTML = "No TextGrid provided.";
		error = 1;
	}else if($("#tierNumber").val() == ""){
		errorContainer.innerHTML = "No base tier number provided.";
		error = 1;
	}else if(isNaN($("#tierNumber").val())){
		errorContainer.innerHTML = "Base tier number value is not a valid number (1 to number of tiers).";
		error = 1;
	}else if($("#fromTierNumber").val() == ""){
		errorContainer.innerHTML = "No first tier number provided.";
		error = 1;
	}else if(isNaN($("#fromTierNumber").val())){
		errorContainer.innerHTML = "first tier number value is not a valid number (1 to number of tiers).";
		error = 1;
	}else if($("#toTierNumber").val() == ""){
		errorContainer.innerHTML = "No last tier number provided.";
		error = 1;
	}else if(isNaN($("#toTierNumber").val())){
		errorContainer.innerHTML = "Last tier number value is not a valid number (1 to number of tiers).";
		error = 1;
	}else{
		errorContainer.innerHTML = "";
	}
	
	return !error;
}

/**
 * Set default values on select textgrid sample
 */
$( "#tgSel" ).change(function() {
	if($(this).val() == "1"){
		$("#tierNumber").val("1");
		$("#fromTierNumber").val("4");
		$("#toTierNumber").val("10");
	}else{
		$("#tierNumber").val("");
		$("#fromTierNumber").val("");
		$("#toTierNumber").val("");
	}
});
