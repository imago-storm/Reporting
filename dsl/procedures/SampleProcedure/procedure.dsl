// This procedure.dsl was generated automatically
// === procedure_autogen starts ===
procedure 'Sample Procedure', description: 'Sample procedure description', {

    step 'Sample Procedure', {
        description = ''
        command = new File(pluginDir, "dsl/procedures/SampleProcedure/steps/SampleProcedure.pl").text
        shell = 'ec-perl'

        }

    formalOutputParameter 'deployed',
        description: 'JSON representation of the deployed application'
// === procedure_autogen ends, checksum: a4b4ad9dbdcb1b2b916b43919caa1a8a ===
// Do not update the code above the line
// procedure properties declaration can be placed in here, like
// property 'property name', value: "value"
}