class Select2Handler {
    constructor(container) {
        this.select2Container = container;
    }

    init() {
        this.select2Container.select2({
        tags: true
        });
    }
    }

    let select2Handler = new Select2Handler($('[data-ref=select2-container]'));
    select2Handler.init();
