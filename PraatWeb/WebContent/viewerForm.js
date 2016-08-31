/**
 * Execute scripts with given action
 * */
function run(action) {
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
	}else{
		errorContainer.innerHTML = "";
	}
	
	return !error;
}