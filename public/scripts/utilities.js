function invokeSorter(action, target, value) {
    document.getElementById(action + "." + target).value = value;
    let notEmpty = true;

    const elements = document.getElementById(action).elements;
    for (let i = 0; i < elements.length; i++) {
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