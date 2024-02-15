<script>
    import Fa from 'svelte-fa'
    import { faHouse } from '@fortawesome/free-solid-svg-icons'

    let home = () => window.location.href = `/`
</script>

<style>
    button {
        opacity: 0.3;
        margin: -1.2em;
    }
    button:hover {
        opacity: 0.7;
    }
</style>

<button
    type="button"
    on:click={home}
    title="Home"
    class="btn btn-primary-outline">
        <Fa icon={faHouse}/>
</button>
