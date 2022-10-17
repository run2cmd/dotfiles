--
-- Diff mode
--
vim.o.diffopt = vim.o.diffopt .. ',vertical,followwrap'
vim.g.ZFDirDiffFileExclude = 'CVS,.git,.svn'
vim.g.ZFDirDiffShowSameFile = 0
