local status, project = pcall(require, "project_nvim")
if not status then
    vim.notify("没有找到 project_nvim")
  return
end

-- nvim-tree 支持
vim.g.nvim_tree_respect_buf_cwd = 1

project.setup({


  detection_methods = {

    "pattern" },
  patterns = {

    ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".sln" },
})

local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("没有找到 telescope")
  return
end
pcall(telescope.load_extension, "projects")
local projects = {
  {
    display_name = "Algorithms Practice",
    path = "/home/amiriox/practice/luogu.org/src/",
  },
  {
    display_name = "Aegir Mod",
    path = "/home/amiriox/project/fabricscn/",
  },  {
    display_name = "Rust Lang Practice",
    path = "/home/amiriox/practice/RustPrac/",
  },  {
    display_name = "Multi-thread Practice",
    path = "/home/amiriox/practice/thread/",
  },
}
--         '/home/amiriox/practice/luogu.org/src/',
--         '/home/amiriox/project/fabricscn/',
--         '/home/amiriox/practice/RustPrac/',
--         '/home/amiriox/practice/thread/'

return projects


