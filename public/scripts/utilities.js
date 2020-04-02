function invokeSorter(action, target, value) {
    document.getElementById(action + "." + target).value = value;
    var notEmpty = true;

    const elements = document.getElementById(action).elements;
    for (var i = 0; i < elements.length; i++) {
        const item = elements.item(i);

        if (item.value == null || item.value.length <= 0) {
            notEmpty = false;
            break;
        }
    }

    if (notEmpty) {
        document.getElementById(action).submit();
    }
}