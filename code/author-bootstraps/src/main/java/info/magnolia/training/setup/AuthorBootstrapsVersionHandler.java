package info.magnolia.training.setup;

import info.magnolia.module.DefaultModuleVersionHandler;
import info.magnolia.module.InstallContext;
import info.magnolia.module.delta.BootstrapSingleResource;
import info.magnolia.module.delta.Task;

import java.util.ArrayList;
import java.util.List;

import javax.jcr.ImportUUIDBehavior;

/**
 * Some tasks to help automate installing Magnolia for author trainings.
 */
public class AuthorBootstrapsVersionHandler extends DefaultModuleVersionHandler {

    @Override
    protected List<Task> getExtraInstallTasks(InstallContext installContext) {
        final List<Task> tasks = new ArrayList<>();

        tasks.add(new BootstrapSingleResource("Bootstrap", "Add the Enterprise Training license",
                    "/mgnl-bootstrap/author-bootstraps/config.modules.enterprise.license.xml",
                    ImportUUIDBehavior.IMPORT_UUID_COLLISION_REMOVE_EXISTING));

        tasks.add(new BootstrapSingleResource("Bootstrap", "Disable common users",
                    "/mgnl-bootstrap/author-bootstraps/users.admin.xml",
                    ImportUUIDBehavior.IMPORT_UUID_COLLISION_REMOVE_EXISTING));

        tasks.add(new BootstrapSingleResource("Bootstrap", "Change the superuser password",
                    "/mgnl-bootstrap/author-bootstraps/users.system.superuser.xml",
                    ImportUUIDBehavior.IMPORT_UUID_COLLISION_REMOVE_EXISTING));

        return tasks;
    }
}
