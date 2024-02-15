<script>
    import '../../node_modules/bootstrap/dist/css/bootstrap.css'
</script>

<style>
    :global(body) {
        background-color: rgb(0,0,0, 0.05);
    }
    :global(input.form-check-input:not(:disabled)) {
        cursor: pointer;
    }
    :global(*:disabled) {
        cursor: not-allowed;
        pointer-events: all !important;
    }
    :global(select) {
        cursor: pointer;
    }
    :global(hr) {
        opacity: 0.1;
    }
</style>

<slot/>
