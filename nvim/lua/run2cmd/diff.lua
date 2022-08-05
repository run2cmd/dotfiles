--
-- Diff mode
--
vim.o.diffopt = vim.o.diffopt .. ',vertical'
vim.g.ZFDirDiffFileExclude = 'CVS,.git,.svn'
vim.g.ZFDirDiffShowSameFile = 0
